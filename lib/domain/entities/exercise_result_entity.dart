import 'package:equatable/equatable.dart';
import 'learning_session_entity.dart';

/// Entity đại diện cho kết quả 1 bài tập thực tế
/// Mỗi lần user làm bài → tạo 1 result mới
class ExerciseResultEntity extends Equatable {
  final String exerciseId;
  final String userId;
  final SkillType skill;
  final int correctAnswers;    // Số câu đúng (có thể = 0)
  final int totalQuestions;    // Tổng số câu
  final double accuracy;       // Độ chính xác 0.0 - 1.0
  final int xpEarned;          // XP kiếm được (có thể = 0)
  final DateTime createdAt;
  final String? lessonId;      // ID bài học (optional)
  final String? sessionId;     // ID session (optional)
  
  const ExerciseResultEntity({
    required this.exerciseId,
    required this.userId,
    required this.skill,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.accuracy,
    required this.xpEarned,
    required this.createdAt,
    this.lessonId,
    this.sessionId,
  });
  
  /// Kiểm tra có phải perfect score không
  bool get isPerfect => accuracy >= 1.0;
  
  /// Kiểm tra có pass không (>= 60%)
  bool get isPass => accuracy >= 0.6;
  
  /// Lấy grade dạng chữ
  String get grade {
    if (accuracy >= 0.9) return 'A';
    if (accuracy >= 0.8) return 'B';
    if (accuracy >= 0.7) return 'C';
    if (accuracy >= 0.6) return 'D';
    return 'F';
  }
  
  /// Tính % accuracy
  int get accuracyPercent => (accuracy * 100).round();
  
  @override
  List<Object?> get props => [
    exerciseId,
    userId,
    skill,
    correctAnswers,
    totalQuestions,
    accuracy,
    xpEarned,
    createdAt,
    lessonId,
    sessionId,
  ];
}

/// XP thưởng theo hành động
class XpRewards {
  static const int correctAnswer = 5;      // Trả lời đúng
  static const int completeLesson = 10;    // Hoàn thành bài
  static const int perfectLesson = 20;     // Perfect score
  static const int speakingPass = 30;      // Speaking AI pass
  static const int dailyStreak = 15;       // Học liên tục mỗi ngày
  
  /// Tính XP dựa trên kết quả
  static int calculateXp({
    required int correctAnswers,
    required int totalQuestions,
    required bool completed,
    required SkillType skill,
  }) {
    int xp = 0;
    
    // Cộng XP cho mỗi câu đúng
    xp += correctAnswers * correctAnswer;
    
    // Cộng XP nếu hoàn thành
    if (completed) {
      xp += completeLesson;
    }
    
    // Cộng thêm nếu perfect
    if (correctAnswers == totalQuestions && totalQuestions > 0) {
      xp += perfectLesson;
    }
    
    // Cộng thêm cho speaking (khó hơn)
    if (skill == SkillType.speaking && completed) {
      xp += speakingPass;
    }
    
    return xp;
  }
}

