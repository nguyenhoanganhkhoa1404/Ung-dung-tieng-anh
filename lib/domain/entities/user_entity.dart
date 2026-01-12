import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String level; // A1, A2, B1, B2, C1, C2
  final int xp;
  final int currentLevel;
  final int streakDays;
  final DateTime? lastStudyDate;
  final DateTime createdAt;
  
  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.level = 'A1',
    this.xp = 0,
    this.currentLevel = 1,
    this.streakDays = 0,
    this.lastStudyDate,
    required this.createdAt,
  });
  
  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? level,
    int? xp,
    int? currentLevel,
    int? streakDays,
    DateTime? lastStudyDate,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      currentLevel: currentLevel ?? this.currentLevel,
      streakDays: streakDays ?? this.streakDays,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        level,
        xp,
        currentLevel,
        streakDays,
        lastStudyDate,
        createdAt,
      ];
}

