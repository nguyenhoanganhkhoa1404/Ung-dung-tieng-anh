import 'package:equatable/equatable.dart';

/// Loại kỹ năng học
enum SkillType {
  vocabulary,  // Từ vựng
  grammar,     // Ngữ pháp
  listening,   // Nghe
  speaking,    // Nói
  reading,     // Đọc
  writing,     // Viết
}

/// Entity đại diện cho 1 phiên học thực tế
/// Mỗi lần user bắt đầu học → tạo 1 session mới
class LearningSessionEntity extends Equatable {
  final String sessionId;
  final String userId;
  final SkillType skill;
  final String lessonId;
  final DateTime startTime;
  final DateTime? endTime;      // null nếu chưa kết thúc
  final int durationMinutes;    // 0 nếu chưa tính được
  final bool completed;         // false nếu user thoát giữa chừng
  
  const LearningSessionEntity({
    required this.sessionId,
    required this.userId,
    required this.skill,
    required this.lessonId,
    required this.startTime,
    this.endTime,
    this.durationMinutes = 0,
    this.completed = false,
  });
  
  /// Kiểm tra session có hợp lệ không
  /// Session chỉ hợp lệ khi duration > 0
  bool get isValid => durationMinutes > 0;
  
  /// Kiểm tra session đang diễn ra
  bool get isOngoing => endTime == null;
  
  /// Tính duration từ start/end time
  int calculateDuration() {
    if (endTime == null) return 0;
    return endTime!.difference(startTime).inMinutes;
  }
  
  @override
  List<Object?> get props => [
    sessionId,
    userId,
    skill,
    lessonId,
    startTime,
    endTime,
    durationMinutes,
    completed,
  ];
}

/// Extension để chuyển đổi string sang enum
extension SkillTypeExtension on SkillType {
  String get value {
    switch (this) {
      case SkillType.vocabulary:
        return 'vocabulary';
      case SkillType.grammar:
        return 'grammar';
      case SkillType.listening:
        return 'listening';
      case SkillType.speaking:
        return 'speaking';
      case SkillType.reading:
        return 'reading';
      case SkillType.writing:
        return 'writing';
    }
  }
  
  String get displayName {
    switch (this) {
      case SkillType.vocabulary:
        return 'Từ vựng';
      case SkillType.grammar:
        return 'Ngữ pháp';
      case SkillType.listening:
        return 'Nghe';
      case SkillType.speaking:
        return 'Nói';
      case SkillType.reading:
        return 'Đọc';
      case SkillType.writing:
        return 'Viết';
    }
  }
  
  static SkillType fromString(String value) {
    switch (value) {
      case 'vocabulary':
        return SkillType.vocabulary;
      case 'grammar':
        return SkillType.grammar;
      case 'listening':
        return SkillType.listening;
      case 'speaking':
        return SkillType.speaking;
      case 'reading':
        return SkillType.reading;
      case 'writing':
        return SkillType.writing;
      default:
        return SkillType.vocabulary;
    }
  }
}

