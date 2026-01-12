import '../entities/lesson_entity.dart';

abstract class LessonRepository {
  Future<List<LessonEntity>> getLessonsByLevel(String level);
  Future<List<LessonEntity>> getLessonsByType(LessonType type);
  Future<LessonEntity> getLessonById(String lessonId);
  Future<List<LessonEntity>> getRecommendedLessons(String userId);
  Future<List<LessonEntity>> searchLessons(String query);
}

