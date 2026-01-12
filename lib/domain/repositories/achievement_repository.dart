import '../entities/achievement_entity.dart';

abstract class AchievementRepository {
  Future<List<AchievementEntity>> getAllAchievements();
  Future<List<UserAchievementEntity>> getUserAchievements(String userId);
  Future<void> updateAchievementProgress(String userId, String achievementId, int value);
  Future<void> unlockAchievement(String userId, String achievementId);
}

