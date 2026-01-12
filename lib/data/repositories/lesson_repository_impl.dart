import '../../core/constants/app_constants.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/remote/firebase_firestore_datasource.dart';
import '../datasources/local/hive_database.dart';
import '../models/lesson_model.dart';

class LessonRepositoryImpl implements LessonRepository {
  final FirebaseFirestoreDataSource firestoreDataSource;
  final HiveDatabase hiveDatabase;
  
  LessonRepositoryImpl({
    required this.firestoreDataSource,
    required this.hiveDatabase,
  });
  
  @override
  Future<List<LessonEntity>> getLessonsByLevel(String level) async {
    try {
      final querySnapshot = await firestoreDataSource.queryCollection(
        AppConstants.lessonsCollection,
        field: 'level',
        isEqualTo: level,
      );
      
      return querySnapshot.docs
          .map((doc) => LessonModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Lấy danh sách bài học thất bại: $e');
    }
  }
  
  @override
  Future<List<LessonEntity>> getLessonsByType(LessonType type) async {
    try {
      final querySnapshot = await firestoreDataSource.queryCollection(
        AppConstants.lessonsCollection,
        field: 'type',
        isEqualTo: type.toString().split('.').last,
      );
      
      return querySnapshot.docs
          .map((doc) => LessonModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Lấy danh sách bài học thất bại: $e');
    }
  }
  
  @override
  Future<LessonEntity> getLessonById(String lessonId) async {
    try {
      // Try to get from cache first
      final cachedLesson = hiveDatabase.getLesson(lessonId);
      if (cachedLesson != null) {
        // Return cached lesson (would need to convert from Map to LessonEntity)
      }
      
      final doc = await firestoreDataSource.getDocument(
        AppConstants.lessonsCollection,
        lessonId,
      );
      
      if (!doc.exists) {
        throw Exception('Bài học không tồn tại');
      }
      
      final lesson = LessonModel.fromFirestore(doc);
      
      // Cache the lesson
      await hiveDatabase.saveLesson(lessonId, lesson.toFirestore());
      
      return lesson;
    } catch (e) {
      throw Exception('Lấy bài học thất bại: $e');
    }
  }
  
  @override
  Future<List<LessonEntity>> getRecommendedLessons(String userId) async {
    // This would integrate with AI recommendation engine
    // For now, return popular lessons
    try {
      final querySnapshot = await firestoreDataSource.queryCollection(
        AppConstants.lessonsCollection,
        limit: 10,
      );
      
      return querySnapshot.docs
          .map((doc) => LessonModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Lấy bài học đề xuất thất bại: $e');
    }
  }
  
  @override
  Future<List<LessonEntity>> searchLessons(String query) async {
    // Simplified search - in production would use Algolia or similar
    try {
      final querySnapshot = await firestoreDataSource.getCollection(
        AppConstants.lessonsCollection,
      );
      
      final lessons = querySnapshot.docs
          .map((doc) => LessonModel.fromFirestore(doc))
          .where((lesson) =>
              lesson.title.toLowerCase().contains(query.toLowerCase()) ||
              lesson.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      return lessons;
    } catch (e) {
      throw Exception('Tìm kiếm bài học thất bại: $e');
    }
  }
}

