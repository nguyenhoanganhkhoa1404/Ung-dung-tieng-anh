import '../domain/entities/lesson_entity.dart';
import '../domain/entities/user_entity.dart';
import '../domain/entities/user_progress_entity.dart';

class RecommendationEngine {
  /// Recommend lessons based on user's level, progress, and weaknesses
  List<LessonEntity> recommendLessons({
    required UserEntity user,
    required List<UserProgressEntity> userProgress,
    required List<LessonEntity> allLessons,
  }) {
    // Filter lessons by user's level
    final levelLessons = allLessons.where((lesson) {
      return lesson.level == user.level;
    }).toList();
    
    // Analyze user's weak skills
    final weakSkills = _analyzeWeakSkills(userProgress);
    
    // Prioritize lessons for weak skills
    final recommendations = <LessonEntity>[];
    
    // Add lessons for weak skills
    for (final skill in weakSkills) {
      final skillLessons = levelLessons.where((lesson) {
        return lesson.type.toString().contains(skill);
      }).toList();
      
      recommendations.addAll(skillLessons.take(2));
    }
    
    // Fill remaining slots with diverse lessons
    final remaining = levelLessons
        .where((lesson) => !recommendations.contains(lesson))
        .take(10 - recommendations.length);
    
    recommendations.addAll(remaining);
    
    return recommendations;
  }
  
  List<String> _analyzeWeakSkills(List<UserProgressEntity> progress) {
    // Calculate accuracy for each skill type
    final skillAccuracy = <String, List<double>>{};
    
    for (final p in progress) {
      // In a real implementation, you would map lessonId to skill type
      // For now, we'll simulate
      final accuracy = p.accuracy;
      
      // This is simplified - in production, you'd have proper skill mapping
      if (accuracy < 0.6) {
        // Return skills that need improvement
        return ['vocabulary', 'grammar', 'listening'];
      }
    }
    
    return ['vocabulary', 'grammar'];
  }
  
  /// Calculate the next optimal study session
  DateTime getNextOptimalStudyTime(UserEntity user) {
    final now = DateTime.now();
    
    if (user.lastStudyDate == null) {
      return now;
    }
    
    // Spaced repetition: recommend studying based on streak
    if (user.streakDays > 7) {
      // Maintain streak with daily study
      return now.add(const Duration(hours: 24));
    } else {
      // Build streak with twice daily recommendations
      return now.add(const Duration(hours: 12));
    }
  }
  
  /// Recommend study duration based on user's level and history
  int getRecommendedStudyDuration(UserEntity user) {
    // Beginners: shorter sessions
    if (user.level == 'A1' || user.level == 'A2') {
      return 15; // 15 minutes
    }
    
    // Intermediate: moderate sessions
    if (user.level == 'B1' || user.level == 'B2') {
      return 25; // 25 minutes
    }
    
    // Advanced: longer sessions
    return 35; // 35 minutes
  }
  
  /// Predict user's next level up date
  DateTime? predictLevelUpDate(UserEntity user, List<UserProgressEntity> progress) {
    if (progress.isEmpty) return null;
    
    // Calculate average XP per day
    final totalDays = progress.length;
    final avgXpPerDay = user.xp / totalDays;
    
    // Calculate days needed to level up (assuming 1000 XP per level)
    final xpNeeded = 1000 - (user.xp % 1000);
    final daysNeeded = (xpNeeded / avgXpPerDay).ceil();
    
    return DateTime.now().add(Duration(days: daysNeeded));
  }
}

