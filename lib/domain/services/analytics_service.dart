import '../entities/learning_session_entity.dart';
import '../../data/repositories/analytics_repository_impl.dart';

/// Service để tính toán analytics THỰC TẾ
/// ❌ KHÔNG SINH DỮ LIỆU GIẢ
/// ✅ Tất cả tính từ database
class AnalyticsService {
  final AnalyticsRepositoryImpl _repository;
  
  AnalyticsService(this._repository);
  
  /// Lấy dashboard data THỰC TẾ
  Future<DashboardData> getDashboardData(String userId) async {
    // Compute from real collections so Dashboard updates even if user profile
    // hasn't been mirrored yet.
    final totalXp = await _repository.calculateTotalXp(userId);
    final totalMinutes = await _repository.calculateTotalLearningMinutes(userId);
    final currentStreak = await _repository.calculateStreak(userId);

    // Tính skill progress từ exercise results
    final skillProgress = await _repository.calculateSkillProgress(userId);

    return DashboardData(
      totalXp: totalXp,
      currentStreak: currentStreak,
      totalLearningHours: totalMinutes / 60.0,
      skillProgress: skillProgress,
    );
  }
  
  /// Refresh streak hàng ngày
  Future<void> refreshStreak(String userId) async {
    final newStreak = await _repository.calculateStreak(userId);
    await _repository.updateUserStreak(userId, newStreak);
  }
  
  /// Lấy học tập theo tuần
  Future<WeeklyReport> getWeeklyReport(String userId) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 7));
    
    final sessions = await _repository.getUserSessions(
      userId,
      startDate: startDate,
      endDate: endDate,
    );
    
    final results = await _repository.getUserExerciseResults(
      userId,
      startDate: startDate,
      endDate: endDate,
    );
    
    // Tính các chỉ số
    final totalMinutes = sessions
        .where((s) => s.isValid)
        .fold<int>(0, (sum, s) => sum + s.durationMinutes);
    
    final totalXp = results
        .fold<int>(0, (sum, r) => sum + r.xpEarned);
    
    final totalExercises = results.length;
    
    final avgAccuracy = results.isEmpty
        ? 0.0
        : results.fold<double>(0.0, (sum, r) => sum + r.accuracy) / results.length;
    
    return WeeklyReport(
      totalMinutes: totalMinutes,
      totalXp: totalXp,
      totalExercises: totalExercises,
      averageAccuracy: avgAccuracy,
      startDate: startDate,
      endDate: endDate,
    );
  }
  
  /// Phát hiện kỹ năng yếu (AI Analysis)
  Future<List<SkillWeakness>> detectWeakSkills(String userId) async {
    final skillProgress = await _repository.calculateSkillProgress(userId);
    final weaknesses = <SkillWeakness>[];
    
    for (var entry in skillProgress.entries) {
      final skill = entry.key;
      final accuracy = entry.value;
      
      // Nếu accuracy < 0.6 (60%) → skill yếu
      if (accuracy < 0.6 && accuracy > 0) {
        weaknesses.add(SkillWeakness(
          skill: skill,
          currentAccuracy: accuracy,
          recommendedPractice: _getRecommendedPractice(skill, accuracy),
        ));
      }
    }
    
    // Sort theo độ yếu (accuracy thấp nhất lên đầu)
    weaknesses.sort((a, b) => a.currentAccuracy.compareTo(b.currentAccuracy));
    
    return weaknesses;
  }
  
  String _getRecommendedPractice(SkillType skill, double accuracy) {
    if (accuracy < 0.4) {
      return 'Luyện tập ${skill.displayName} ít nhất 30 phút/ngày';
    } else if (accuracy < 0.5) {
      return 'Luyện tập ${skill.displayName} 20 phút/ngày';
    } else {
      return 'Luyện tập ${skill.displayName} 15 phút/ngày';
    }
  }
  
  /// Heatmap học tập theo ngày (30 ngày gần nhất)
  Future<Map<DateTime, int>> getStudyHeatmap(String userId) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 30));
    
    final sessions = await _repository.getUserSessions(
      userId,
      startDate: startDate,
      endDate: endDate,
    );
    
    final heatmap = <DateTime, int>{};
    
    // Tính tổng phút học mỗi ngày
    for (var session in sessions) {
      if (!session.isValid) continue;
      
      final date = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );
      
      heatmap[date] = (heatmap[date] ?? 0) + session.durationMinutes;
    }
    
    return heatmap;
  }
}

/// Data class cho Dashboard
class DashboardData {
  final int totalXp;
  final int currentStreak;
  final double totalLearningHours;
  final Map<SkillType, double> skillProgress;
  
  DashboardData({
    required this.totalXp,
    required this.currentStreak,
    required this.totalLearningHours,
    required this.skillProgress,
  });
}

/// Data class cho báo cáo tuần
class WeeklyReport {
  final int totalMinutes;
  final int totalXp;
  final int totalExercises;
  final double averageAccuracy;
  final DateTime startDate;
  final DateTime endDate;
  
  WeeklyReport({
    required this.totalMinutes,
    required this.totalXp,
    required this.totalExercises,
    required this.averageAccuracy,
    required this.startDate,
    required this.endDate,
  });
  
  double get totalHours => totalMinutes / 60.0;
  int get averageAccuracyPercent => (averageAccuracy * 100).round();
}

/// Data class cho kỹ năng yếu
class SkillWeakness {
  final SkillType skill;
  final double currentAccuracy;
  final String recommendedPractice;
  
  SkillWeakness({
    required this.skill,
    required this.currentAccuracy,
    required this.recommendedPractice,
  });
  
  int get accuracyPercent => (currentAccuracy * 100).round();
}

