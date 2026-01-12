import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/learning_session_entity.dart';

class LearningSessionModel extends LearningSessionEntity {
  const LearningSessionModel({
    required super.sessionId,
    required super.userId,
    required super.skill,
    required super.lessonId,
    required super.startTime,
    super.endTime,
    super.durationMinutes,
    super.completed,
  });
  
  /// Tạo từ Firestore
  factory LearningSessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return LearningSessionModel(
      sessionId: doc.id,
      userId: data['user_id'] ?? '',
      skill: SkillTypeExtension.fromString(data['skill'] ?? 'vocabulary'),
      lessonId: data['lesson_id'] ?? '',
      startTime: (data['start_time'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endTime: (data['end_time'] as Timestamp?)?.toDate(),
      durationMinutes: data['duration_minutes'] ?? 0,
      completed: data['completed'] ?? false,
    );
  }
  
  /// Chuyển sang Map
  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'skill': skill.value,
      'lesson_id': lessonId,
      'start_time': Timestamp.fromDate(startTime),
      'end_time': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'duration_minutes': durationMinutes,
      'completed': completed,
    };
  }
  
  /// Tạo session mới khi user bắt đầu học
  factory LearningSessionModel.startNew({
    required String userId,
    required SkillType skill,
    required String lessonId,
  }) {
    return LearningSessionModel(
      sessionId: '', // Firestore sẽ tự tạo ID
      userId: userId,
      skill: skill,
      lessonId: lessonId,
      startTime: DateTime.now(),
      endTime: null,              // Chưa kết thúc
      durationMinutes: 0,         // Chưa tính được
      completed: false,           // Chưa hoàn thành
    );
  }
  
  /// Kết thúc session
  LearningSessionModel complete() {
    final now = DateTime.now();
    // Web/mobile: users can finish very fast (< 1 minute) → count at least 1 minute
    final duration = now.difference(startTime).inMinutes.clamp(1, 24 * 60);
    
    return LearningSessionModel(
      sessionId: sessionId,
      userId: userId,
      skill: skill,
      lessonId: lessonId,
      startTime: startTime,
      endTime: now,
      durationMinutes: duration,
      completed: true,
    );
  }
}

