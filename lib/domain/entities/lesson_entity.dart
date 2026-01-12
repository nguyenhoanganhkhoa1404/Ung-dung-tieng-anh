import 'package:equatable/equatable.dart';

enum LessonType {
  vocabulary,
  grammar,
  listening,
  speaking,
  reading,
  writing,
}

class LessonEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final LessonType type;
  final String level; // A1, A2, B1, B2, C1, C2
  final String? thumbnailUrl;
  final int durationMinutes;
  final int xpReward;
  final List<String> topics;
  final bool isPremium;
  final DateTime createdAt;
  
  const LessonEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.level,
    this.thumbnailUrl,
    required this.durationMinutes,
    required this.xpReward,
    this.topics = const [],
    this.isPremium = false,
    required this.createdAt,
  });
  
  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        level,
        thumbnailUrl,
        durationMinutes,
        xpReward,
        topics,
        isPremium,
        createdAt,
      ];
}

