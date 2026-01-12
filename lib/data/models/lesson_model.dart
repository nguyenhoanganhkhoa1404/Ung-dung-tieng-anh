import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/lesson_entity.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.level,
    super.thumbnailUrl,
    required super.durationMinutes,
    required super.xpReward,
    super.topics,
    super.isPremium,
    required super.createdAt,
  });
  
  factory LessonModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LessonModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: LessonType.values.firstWhere(
        (e) => e.toString() == 'LessonType.${data['type']}',
        orElse: () => LessonType.vocabulary,
      ),
      level: data['level'] ?? 'A1',
      thumbnailUrl: data['thumbnailUrl'],
      durationMinutes: data['durationMinutes'] ?? 0,
      xpReward: data['xpReward'] ?? 0,
      topics: List<String>.from(data['topics'] ?? []),
      isPremium: data['isPremium'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'level': level,
      'thumbnailUrl': thumbnailUrl,
      'durationMinutes': durationMinutes,
      'xpReward': xpReward,
      'topics': topics,
      'isPremium': isPremium,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

