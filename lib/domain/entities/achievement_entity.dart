import 'package:equatable/equatable.dart';

enum AchievementType {
  streak,
  lessonCompleted,
  vocabularyMastered,
  levelUp,
  perfectScore,
}

class AchievementEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final AchievementType type;
  final String? iconUrl;
  final int requiredValue;
  final int xpReward;
  final DateTime createdAt;
  
  const AchievementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.iconUrl,
    required this.requiredValue,
    required this.xpReward,
    required this.createdAt,
  });
  
  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        iconUrl,
        requiredValue,
        xpReward,
        createdAt,
      ];
}

class UserAchievementEntity extends Equatable {
  final String id;
  final String userId;
  final String achievementId;
  final int currentValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  
  const UserAchievementEntity({
    required this.id,
    required this.userId,
    required this.achievementId,
    this.currentValue = 0,
    this.isUnlocked = false,
    this.unlockedAt,
  });
  
  @override
  List<Object?> get props => [
        id,
        userId,
        achievementId,
        currentValue,
        isUnlocked,
        unlockedAt,
      ];
}

