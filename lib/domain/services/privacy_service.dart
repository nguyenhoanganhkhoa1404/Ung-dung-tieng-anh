import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../entities/user_profile_entity.dart';
import '../entities/learning_session_entity.dart';
import '../entities/exercise_result_entity.dart';
import '../../data/repositories/analytics_repository_impl.dart';

/// Service xử lý quyền riêng tư và export dữ liệu
class PrivacyService {
  final AnalyticsRepositoryImpl _repository;
  
  PrivacyService(this._repository);
  
  /// Export tất cả dữ liệu của user thành JSON
  Future<File> exportUserData(String userId) async {
    // Lấy tất cả dữ liệu
    final profile = await _repository.getUserProfile(userId);
    final sessions = await _repository.getUserSessions(userId);
    final results = await _repository.getUserExerciseResults(userId);
    
    // Tạo JSON
    final data = {
      'exported_at': DateTime.now().toIso8601String(),
      'user_profile': _profileToJson(profile),
      'learning_sessions': sessions.map(_sessionToJson).toList(),
      'exercise_results': results.map(_resultToJson).toList(),
      'statistics': {
        'total_sessions': sessions.length,
        'total_exercises': results.length,
        'total_xp': profile?.totalXp ?? 0,
        'total_learning_hours': profile?.totalLearningHours ?? 0,
      },
    };
    
    // Ghi file
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_english_learning_data_${DateTime.now().millisecondsSinceEpoch}.json');
    
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(data),
    );
    
    return file;
  }
  
  /// Lấy lịch sử học tập
  Future<List<LearningSessionEntity>> getStudyHistory(
    String userId, {
    int days = 30,
  }) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    
    return await _repository.getUserSessions(
      userId,
      startDate: startDate,
      endDate: endDate,
    );
  }
  
  /// Lấy lịch sử bài tập
  Future<List<ExerciseResultEntity>> getExerciseHistory(
    String userId, {
    int days = 30,
  }) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    
    return await _repository.getUserExerciseResults(
      userId,
      startDate: startDate,
      endDate: endDate,
    );
  }
  
  /// Xóa dữ liệu cũ (GDPR compliance)
  Future<void> deleteOldData(String userId, {int olderThanDays = 365}) async {
    // TODO: Implement deletion logic
    // Cần thêm methods trong repository để xóa data cũ
    throw UnimplementedError('Deletion not implemented yet');
  }
  
  // Private helpers
  
  Map<String, dynamic> _profileToJson(UserProfileEntity? profile) {
    if (profile == null) return {};
    return {
      'user_id': profile.userId,
      'name': profile.name,
      'email': profile.email,
      'created_at': profile.createdAt.toIso8601String(),
      'total_xp': profile.totalXp,
      'current_streak': profile.currentStreak,
      'total_learning_minutes': profile.totalLearningMinutes,
      'current_level': profile.currentLevel,
    };
  }
  
  Map<String, dynamic> _sessionToJson(LearningSessionEntity session) {
    return {
      'session_id': session.sessionId,
      'skill': session.skill.value,
      'lesson_id': session.lessonId,
      'start_time': session.startTime.toIso8601String(),
      'end_time': session.endTime?.toIso8601String(),
      'duration_minutes': session.durationMinutes,
      'completed': session.completed,
    };
  }
  
  Map<String, dynamic> _resultToJson(ExerciseResultEntity result) {
    return {
      'exercise_id': result.exerciseId,
      'skill': result.skill.value,
      'correct_answers': result.correctAnswers,
      'total_questions': result.totalQuestions,
      'accuracy': result.accuracy,
      'xp_earned': result.xpEarned,
      'created_at': result.createdAt.toIso8601String(),
      'grade': result.grade,
    };
  }
}

