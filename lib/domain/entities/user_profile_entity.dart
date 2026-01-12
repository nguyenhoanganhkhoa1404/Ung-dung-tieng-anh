import 'package:equatable/equatable.dart';

/// Entity đại diện cho profile người dùng
/// ❌ KHÔNG CHO PHÉP NULL
/// ✅ Tất cả giá trị mặc định = 0
class UserProfileEntity extends Equatable {
  final String userId;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime lastActive;
  
  // Các chỉ số tổng hợp - THỰC TẾ từ database
  final int totalXp;              // Tổng XP từ exercise_results
  final int currentStreak;        // Streak học liên tục
  final int totalLearningMinutes; // Tổng thời gian học (phút)
  final String avatarUrl;
  final String currentLevel;      // A1, A2, B1, B2, C1, C2
  
  const UserProfileEntity({
    required this.userId,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.lastActive,
    this.totalXp = 0,              // Mặc định = 0
    this.currentStreak = 0,        // Mặc định = 0
    this.totalLearningMinutes = 0, // Mặc định = 0
    this.avatarUrl = '',
    this.currentLevel = 'A1',
  });
  
  /// Tính số giờ học từ phút
  double get totalLearningHours => totalLearningMinutes / 60.0;
  
  /// Kiểm tra xem user có phải là newbie không
  bool get isNewbie => totalXp == 0 && totalLearningMinutes == 0;
  
  @override
  List<Object?> get props => [
    userId,
    name,
    email,
    createdAt,
    lastActive,
    totalXp,
    currentStreak,
    totalLearningMinutes,
    avatarUrl,
    currentLevel,
  ];
}

