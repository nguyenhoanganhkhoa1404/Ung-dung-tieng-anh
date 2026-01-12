import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/entities/learning_session_entity.dart';
import '../../domain/entities/exercise_result_entity.dart';
import '../models/user_profile_model.dart';
import '../models/learning_session_model.dart';
import '../models/exercise_result_model.dart';

/// Repository để quản lý dữ liệu analytics THỰC TẾ
/// ❌ KHÔNG SINH DỮ LIỆU GIẢ
/// ✅ Tất cả dữ liệu từ Firestore
class AnalyticsRepositoryImpl {
  final FirebaseFirestore _firestore;
  
  AnalyticsRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ========================================================================
  // LEADERBOARD (Public stats mirror)
  // ========================================================================
  Future<void> _upsertLeaderboardEntry({
    required String userId,
    String? name,
    int? totalXp,
    int? currentStreak,
    int? totalLearningMinutes,
  }) async {
    // Chỉ lưu dữ liệu public (không lưu email)
    final data = <String, dynamic>{
      'user_id': userId,
      if (name != null) 'name': name,
      if (totalXp != null) 'total_xp': totalXp,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (totalLearningMinutes != null) 'total_learning_minutes': totalLearningMinutes,
      'updated_at': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('leaderboard').doc(userId).set(
          data,
          SetOptions(merge: true),
        );
  }
  
  // ============================================================================
  // USER PROFILE
  // ============================================================================
  
  /// Lấy profile user - NẾU KHÔNG CÓ TRẢ VỀ NULL
  Future<UserProfileEntity?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      
      if (!doc.exists) return null;
      
      return UserProfileModel.fromFirestore(doc);
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }
  
  /// Tạo user mới với giá trị mặc định = 0
  Future<void> createUser({
    required String userId,
    required String name,
    required String email,
  }) async {
    final user = UserProfileModel.createNew(
      userId: userId,
      name: name,
      email: email,
    );
    
    await _firestore
        .collection('users')
        .doc(userId)
        .set(user.toFirestore());

    // Mirror sang leaderboard (public)
    await _upsertLeaderboardEntry(
      userId: userId,
      name: name,
      totalXp: 0,
      currentStreak: 0,
      totalLearningMinutes: 0,
    );
  }
  
  /// Cập nhật profile user
  Future<void> updateUserProfile(UserProfileModel user) async {
    await _firestore
        .collection('users')
        .doc(user.userId)
        .update(user.toFirestore());

    // Mirror public stats
    await _upsertLeaderboardEntry(
      userId: user.userId,
      name: user.name,
      totalXp: user.totalXp,
      currentStreak: user.currentStreak,
      totalLearningMinutes: user.totalLearningMinutes,
    );
  }
  
  // ============================================================================
  // LEARNING SESSIONS
  // ============================================================================
  
  /// Bắt đầu session học mới
  Future<String> startLearningSession({
    required String userId,
    required SkillType skill,
    required String lessonId,
  }) async {
    final session = LearningSessionModel.startNew(
      userId: userId,
      skill: skill,
      lessonId: lessonId,
    );
    
    final docRef = await _firestore
        .collection('learning_sessions')
        .add(session.toFirestore());
    
    return docRef.id;
  }
  
  /// Kết thúc session
  Future<void> completeLearningSession(String sessionId) async {
    final doc = await _firestore
        .collection('learning_sessions')
        .doc(sessionId)
        .get();
    
    if (!doc.exists) return;
    
    final session = LearningSessionModel.fromFirestore(doc);
    final completedSession = session.complete();
    
    await _firestore
        .collection('learning_sessions')
        .doc(sessionId)
        .update(completedSession.toFirestore());
    
    // Cập nhật total_learning_minutes của user
    await _updateUserLearningMinutes(
      session.userId,
      completedSession.durationMinutes,
    );
  }
  
  /// Lấy tất cả sessions của user
  /// CHỈ DÙNG INDEX CƠ BẢN: user_id + start_time
  Future<List<LearningSessionEntity>> getUserSessions(
    String userId, {
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Query đơn giản - CHỈ dùng index có sẵn
    final query = _firestore
        .collection('learning_sessions')
        .where('user_id', isEqualTo: userId)
        .orderBy('start_time', descending: true);
    
    // KHÔNG thêm where() cho date - sẽ filter trong memory
    
    final snapshot = await query.get();
    
    var sessions = snapshot.docs
        .map((doc) => LearningSessionModel.fromFirestore(doc))
        .toList();
    
    // Filter date trong memory
    if (startDate != null) {
      sessions = sessions.where((s) => 
        s.startTime.isAfter(startDate) || s.startTime.isAtSameMomentAs(startDate)
      ).toList();
    }
    
    if (endDate != null) {
      sessions = sessions.where((s) => 
        s.startTime.isBefore(endDate) || s.startTime.isAtSameMomentAs(endDate)
      ).toList();
    }
    
    // Apply limit sau khi filter
    if (limit != null && sessions.length > limit) {
      sessions = sessions.sublist(0, limit);
    }
    
    return sessions;
  }
  
  // ============================================================================
  // EXERCISE RESULTS
  // ============================================================================
  
  /// Lưu kết quả bài tập THỰC TẾ
  Future<void> saveExerciseResult({
    required String userId,
    required SkillType skill,
    required int correctAnswers,
    required int totalQuestions,
    required bool completed,
    String? lessonId,
    String? sessionId,
  }) async {
    final result = ExerciseResultModel.fromExercise(
      userId: userId,
      skill: skill,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      completed: completed,
      lessonId: lessonId,
      sessionId: sessionId,
    );
    
    await _firestore
        .collection('exercise_results')
        .add(result.toFirestore());
    
    // Cập nhật total_xp của user
    await _updateUserXp(userId, result.xpEarned);
  }
  
  /// Lấy tất cả results của user
  /// Đảm bảo khớp chính xác với Index: user_id (ASC) + created_at (DESC)
  Future<List<ExerciseResultEntity>> getUserExerciseResults(
    String userId, {
    SkillType? skill,
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Query ĐƠN GIẢN NHẤT - Khớp 100% với Index
      final query = _firestore
          .collection('exercise_results')
          .where('user_id', isEqualTo: userId)
          .orderBy('created_at', descending: true); // Hướng DESCENDING ⬇️
      
      final snapshot = await query.get();
      
      var results = snapshot.docs
          .map((doc) => ExerciseResultModel.fromFirestore(doc))
          .toList();
      
      // Mọi bộ lọc khác thực hiện trong Memory để TRIỆT ĐỂ không bao giờ lỗi Index nữa
      if (skill != null) {
        results = results.where((r) => r.skill == skill).toList();
      }
      
      if (startDate != null) {
        results = results.where((r) => 
          r.createdAt.isAfter(startDate) || r.createdAt.isAtSameMomentAs(startDate)
        ).toList();
      }
      
      if (endDate != null) {
        results = results.where((r) => 
          r.createdAt.isBefore(endDate) || r.createdAt.isAtSameMomentAs(endDate)
        ).toList();
      }
      
      if (limit != null && results.length > limit) {
        results = results.sublist(0, limit);
      }
      
      return results;
    } catch (e) {
      print('Error in getUserExerciseResults: $e');
      rethrow;
    }
  }
  
  // ============================================================================
  // PRIVATE HELPERS - Cập nhật user stats
  // ============================================================================
  
  /// Cập nhật tổng XP của user
  Future<void> _updateUserXp(String userId, int xpToAdd) async {
    await _firestore.collection('users').doc(userId).set({
      'user_id': userId,
      'total_xp': FieldValue.increment(xpToAdd),
      'last_active': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Update leaderboard (increment)
    await _firestore.collection('leaderboard').doc(userId).set({
      'user_id': userId,
      'total_xp': FieldValue.increment(xpToAdd),
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
  
  /// Cập nhật tổng thời gian học
  Future<void> _updateUserLearningMinutes(String userId, int minutes) async {
    await _firestore.collection('users').doc(userId).set({
      'user_id': userId,
      'total_learning_minutes': FieldValue.increment(minutes),
      'last_active': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Update leaderboard (increment)
    await _firestore.collection('leaderboard').doc(userId).set({
      'user_id': userId,
      'total_learning_minutes': FieldValue.increment(minutes),
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
  
  /// Cập nhật streak
  Future<void> updateUserStreak(String userId, int newStreak) async {
    await _firestore.collection('users').doc(userId).set({
      'user_id': userId,
      'current_streak': newStreak,
      'last_active': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Mirror sang leaderboard
    await _upsertLeaderboardEntry(
      userId: userId,
      currentStreak: newStreak,
    );
  }
  
  // ============================================================================
  // STATISTICS - TẤT CẢ TÍNH TỪ DATABASE
  // ============================================================================
  
  /// Tính tổng XP từ exercise_results (REAL)
  Future<int> calculateTotalXp(String userId) async {
    final results = await getUserExerciseResults(userId);
    return results.fold<int>(0, (sum, result) => sum + result.xpEarned);
  }
  
  /// Tính tổng thời gian học từ sessions (REAL)
  Future<int> calculateTotalLearningMinutes(String userId) async {
    final sessions = await getUserSessions(userId);
    return sessions
        .where((s) => s.isValid) // Chỉ tính session hợp lệ
        .fold<int>(0, (sum, session) => sum + session.durationMinutes);
  }
  
  /// Tính streak THỰC TẾ
  Future<int> calculateStreak(String userId) async {
    final sessions = await getUserSessions(userId);
    
    if (sessions.isEmpty) return 0;
    
    // Sort theo ngày
    final sessionsByDate = <DateTime, List<LearningSessionEntity>>{};
    
    for (var session in sessions) {
      if (!session.isValid) continue; // Chỉ tính session hợp lệ (duration > 0)
      
      final date = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );
      
      sessionsByDate.putIfAbsent(date, () => []).add(session);
    }
    
    // Tính tổng thời gian học mỗi ngày
    final dailyMinutes = <DateTime, int>{};
    sessionsByDate.forEach((date, sessions) {
      final totalMinutes = sessions.fold<int>(
        0,
        (sum, s) => sum + s.durationMinutes,
      );
      dailyMinutes[date] = totalMinutes;
    });
    
    // Tính streak từ hôm nay trở về trước
    int streak = 0;
    var currentDate = DateTime.now();
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
    
    while (true) {
      final minutes = dailyMinutes[currentDate] ?? 0;
      
      // Nếu học >= 10 phút → streak +1
      if (minutes >= 10) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        // Nếu là hôm nay và chưa học đủ → không reset streak
        final today = DateTime.now();
        final isToday = currentDate.year == today.year &&
            currentDate.month == today.month &&
            currentDate.day == today.day;
        
        if (isToday && streak == 0) {
          return 0; // Hôm nay chưa học gì
        }
        
        break; // Ngày nào đó không học đủ → dừng
      }
    }
    
    return streak;
  }
  
  /// Tính progress từng skill (REAL - CÓ THỂ = 0%)
  /// Lấy tất cả results 1 lần rồi filter trong memory để tránh cần index phức tạp
  Future<Map<SkillType, double>> calculateSkillProgress(String userId) async {
    // Lấy TẤT CẢ exercise results của user (dùng index có sẵn: user_id + created_at)
    final results = await getUserExerciseResults(userId);
    
    final progressMap = <SkillType, double>{};
    
    // Nhóm results theo skill trong memory (không cần query Firestore)
    for (var skill in SkillType.values) {
      final skillResults = results.where((r) => r.skill == skill).toList();
      
      if (skillResults.isEmpty) {
        progressMap[skill] = 0.0; // Chưa làm bài nào → 0%
      } else {
        // Tính trung bình accuracy
        final totalAccuracy = skillResults.fold<double>(
          0.0,
          (sum, r) => sum + r.accuracy,
        );
        progressMap[skill] = totalAccuracy / skillResults.length;
      }
    }
    
    return progressMap;
  }
}

