import '../entities/user_progress_entity.dart';

abstract class ProgressRepository {
  Future<List<UserProgressEntity>> getUserProgress(String userId);
  Future<UserProgressEntity> getLessonProgress(String userId, String lessonId);
  Future<void> saveProgress(UserProgressEntity progress);
  Future<void> updateProgress(UserProgressEntity progress);
  Future<Map<String, dynamic>> getUserStatistics(String userId);
}

