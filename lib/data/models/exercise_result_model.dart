import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/exercise_result_entity.dart';
import '../../domain/entities/learning_session_entity.dart';

class ExerciseResultModel extends ExerciseResultEntity {
  const ExerciseResultModel({
    required super.exerciseId,
    required super.userId,
    required super.skill,
    required super.correctAnswers,
    required super.totalQuestions,
    required super.accuracy,
    required super.xpEarned,
    required super.createdAt,
    super.lessonId,
    super.sessionId,
  });
  
  /// Tạo từ Firestore
  factory ExerciseResultModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return ExerciseResultModel(
      exerciseId: doc.id,
      userId: data['user_id'] ?? '',
      skill: SkillTypeExtension.fromString(data['skill'] ?? 'vocabulary'),
      correctAnswers: data['correct_answers'] ?? 0,
      totalQuestions: data['total_questions'] ?? 0,
      accuracy: (data['accuracy'] ?? 0.0).toDouble(),
      xpEarned: data['xp_earned'] ?? 0,
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lessonId: data['lesson_id'],
      sessionId: data['session_id'],
    );
  }
  
  /// Chuyển sang Map
  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'skill': skill.value,
      'correct_answers': correctAnswers,
      'total_questions': totalQuestions,
      'accuracy': accuracy,
      'xp_earned': xpEarned,
      'created_at': Timestamp.fromDate(createdAt),
      'lesson_id': lessonId,
      'session_id': sessionId,
    };
  }
  
  /// Tạo result mới từ bài tập thực tế
  factory ExerciseResultModel.fromExercise({
    required String userId,
    required SkillType skill,
    required int correctAnswers,
    required int totalQuestions,
    required bool completed,
    String? lessonId,
    String? sessionId,
  }) {
    // Tính accuracy THỰC TẾ
    final accuracy = totalQuestions > 0 
        ? correctAnswers / totalQuestions 
        : 0.0;
    
    // Tính XP dựa trên công thức
    final xp = XpRewards.calculateXp(
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      completed: completed,
      skill: skill,
    );
    
    return ExerciseResultModel(
      exerciseId: '', // Firestore tự tạo
      userId: userId,
      skill: skill,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      accuracy: accuracy,
      xpEarned: xp,
      createdAt: DateTime.now(),
      lessonId: lessonId,
      sessionId: sessionId,
    );
  }
}

