import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.level,
    super.xp,
    super.currentLevel,
    super.streakDays,
    super.lastStudyDate,
    required super.createdAt,
  });
  
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      level: entity.level,
      xp: entity.xp,
      currentLevel: entity.currentLevel,
      streakDays: entity.streakDays,
      lastStudyDate: entity.lastStudyDate,
      createdAt: entity.createdAt,
    );
  }
  
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};

    Timestamp? _ts(dynamic v) => v is Timestamp ? v : null;
    int _asInt(dynamic v, [int fallback = 0]) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return fallback;
    }

    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      // Support both schemas:
      // - auth schema: displayName/photoUrl/createdAt/xp/streakDays/currentLevel/level
      // - analytics schema: name/avatar_url/created_at/total_xp/current_streak/current_level
      displayName: data['displayName'] ?? data['name'],
      photoUrl: data['photoUrl'] ?? data['avatar_url'],
      level: data['level'] ?? data['current_level'] ?? 'A1',
      xp: _asInt(data['xp'] ?? data['total_xp']),
      currentLevel: _asInt(data['currentLevel'] ?? data['current_level'] ?? 1, 1),
      streakDays: _asInt(data['streakDays'] ?? data['current_streak']),
      lastStudyDate: _ts(data['lastStudyDate'])?.toDate(),
      createdAt:
          (_ts(data['createdAt']) ?? _ts(data['created_at']) ?? Timestamp.now())
              .toDate(),
    );
  }
  
  Map<String, dynamic> toFirestore() {
    final createdAtTs = Timestamp.fromDate(createdAt);
    final lastStudyTs =
        lastStudyDate != null ? Timestamp.fromDate(lastStudyDate!) : null;

    return {
      'email': email,
      // Auth schema keys
      'displayName': displayName,
      'photoUrl': photoUrl,
      'level': level,
      'xp': xp,
      'currentLevel': currentLevel,
      'streakDays': streakDays,
      'lastStudyDate': lastStudyTs,
      'createdAt': createdAtTs,

      // Analytics schema keys (for compatibility with Dashboard/Profile)
      'name': displayName,
      'avatar_url': photoUrl,
      'current_level': level,
      'total_xp': xp,
      'current_streak': streakDays,
      'created_at': createdAtTs,
    };
  }
}

