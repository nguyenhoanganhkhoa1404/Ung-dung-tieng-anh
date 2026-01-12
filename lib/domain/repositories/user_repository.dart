import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUserById(String userId);
  Future<void> updateUser(UserEntity user);
  Future<void> updateUserLevel(String userId, String level);
  Future<void> addXP(String userId, int xp);
  Future<void> updateStreak(String userId, int streakDays);
  Future<void> updateLastStudyDate(String userId, DateTime date);
}

