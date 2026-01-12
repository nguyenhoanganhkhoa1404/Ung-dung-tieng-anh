import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.userId,
    required super.name,
    required super.email,
    required super.createdAt,
    required super.lastActive,
    super.totalXp,
    super.currentStreak,
    super.totalLearningMinutes,
    super.avatarUrl,
    super.currentLevel,
  });
  
  /// Tạo UserProfile từ Firestore
  factory UserProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return UserProfileModel(
      userId: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActive: (data['last_active'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalXp: data['total_xp'] ?? 0,              // Mặc định 0
      currentStreak: data['current_streak'] ?? 0,  // Mặc định 0
      totalLearningMinutes: data['total_learning_minutes'] ?? 0, // Mặc định 0
      avatarUrl: data['avatar_url'] ?? '',
      currentLevel: data['current_level'] ?? 'A1',
    );
  }
  
  /// Chuyển sang Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'created_at': Timestamp.fromDate(createdAt),
      'last_active': Timestamp.fromDate(lastActive),
      'total_xp': totalXp,
      'current_streak': currentStreak,
      'total_learning_minutes': totalLearningMinutes,
      'avatar_url': avatarUrl,
      'current_level': currentLevel,
    };
  }
  
  /// Tạo user mới với giá trị mặc định = 0
  factory UserProfileModel.createNew({
    required String userId,
    required String name,
    required String email,
  }) {
    return UserProfileModel(
      userId: userId,
      name: name,
      email: email,
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
      totalXp: 0,                 // Bắt đầu từ 0
      currentStreak: 0,           // Bắt đầu từ 0
      totalLearningMinutes: 0,    // Bắt đầu từ 0
      avatarUrl: '',
      currentLevel: 'A1',
    );
  }
  
  /// Copy với thay đổi
  UserProfileModel copyWith({
    String? name,
    String? email,
    DateTime? lastActive,
    int? totalXp,
    int? currentStreak,
    int? totalLearningMinutes,
    String? avatarUrl,
    String? currentLevel,
  }) {
    return UserProfileModel(
      userId: userId,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt,
      lastActive: lastActive ?? this.lastActive,
      totalXp: totalXp ?? this.totalXp,
      currentStreak: currentStreak ?? this.currentStreak,
      totalLearningMinutes: totalLearningMinutes ?? this.totalLearningMinutes,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentLevel: currentLevel ?? this.currentLevel,
    );
  }
}

