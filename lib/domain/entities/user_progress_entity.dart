import 'package:equatable/equatable.dart';

class UserProgressEntity extends Equatable {
  final String id;
  final String userId;
  final String lessonId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime startedAt;
  final int timeSpentSeconds;
  
  const UserProgressEntity({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    this.isCompleted = false,
    this.completedAt,
    required this.startedAt,
    this.timeSpentSeconds = 0,
  });
  
  double get accuracy => totalQuestions > 0 ? correctAnswers / totalQuestions : 0;
  
  @override
  List<Object?> get props => [
        id,
        userId,
        lessonId,
        score,
        totalQuestions,
        correctAnswers,
        isCompleted,
        completedAt,
        startedAt,
        timeSpentSeconds,
      ];
}

