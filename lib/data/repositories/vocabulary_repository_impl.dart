import 'dart:math';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/vocabulary_entity.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasources/remote/firebase_firestore_datasource.dart';
import '../datasources/local/hive_database.dart';
import '../models/vocabulary_model.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  final FirebaseFirestoreDataSource firestoreDataSource;
  final HiveDatabase hiveDatabase;
  
  VocabularyRepositoryImpl({
    required this.firestoreDataSource,
    required this.hiveDatabase,
  });

  static const int _studyCountDefault = 5;

  List<VocabularyEntity> _pickRandom(List<VocabularyEntity> items, int count) {
    if (items.isEmpty) return const [];
    final shuffled = List<VocabularyEntity>.from(items)..shuffle(Random());
    return shuffled.take(min(count, shuffled.length)).toList();
  }
  
  @override
  Future<List<VocabularyEntity>> getVocabularyByLevel(String level) async {
    try {
      // 1) Prefer offline cache for fast random study sets.
      final cached = hiveDatabase
          .getAllVocabulary()
          .map(VocabularyModel.fromCache)
          .where((v) => v.level == level)
          .toList();

      if (cached.length >= _studyCountDefault) {
        return _pickRandom(cached, _studyCountDefault);
      }

      // 2) If cache is empty/insufficient, fetch from Firestore and cache it.
      final querySnapshot = await firestoreDataSource.queryCollection(
        AppConstants.vocabularyCollection,
        field: 'level',
        isEqualTo: level,
        // If you seed 1000 words/level, this will fetch all of them the first time.
        limit: 1000,
      );
      
      final vocabulary = querySnapshot.docs
          .map((doc) => VocabularyModel.fromFirestore(doc))
          .toList();
      
      // Cache vocabulary
      for (var vocab in vocabulary) {
        try {
          // IMPORTANT: Hive không lưu được Timestamp, nên dùng toCache()
          await hiveDatabase.saveVocabulary(vocab.id, vocab.toCache());
        } catch (_) {
          // Cache fail không được làm fail việc load từ vựng
        }
      }
      
      // Study mode: return random 5 each load.
      return _pickRandom(vocabulary, _studyCountDefault);
    } catch (e) {
      throw Exception('Lấy từ vựng thất bại: $e');
    }
  }
  
  @override
  Future<VocabularyEntity> getVocabularyById(String vocabId) async {
    try {
      final doc = await firestoreDataSource.getDocument(
        AppConstants.vocabularyCollection,
        vocabId,
      );
      
      if (!doc.exists) {
        throw Exception('Từ vựng không tồn tại');
      }
      
      return VocabularyModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Lấy từ vựng thất bại: $e');
    }
  }
  
  @override
  Future<List<VocabularyEntity>> searchVocabulary(String query) async {
    try {
      final querySnapshot = await firestoreDataSource.getCollection(
        AppConstants.vocabularyCollection,
      );
      
      final vocabulary = querySnapshot.docs
          .map((doc) => VocabularyModel.fromFirestore(doc))
          .where((vocab) =>
              vocab.word.toLowerCase().contains(query.toLowerCase()) ||
              vocab.meaning.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      return vocabulary;
    } catch (e) {
      throw Exception('Tìm kiếm từ vựng thất bại: $e');
    }
  }
  
  @override
  Future<List<VocabularyEntity>> getDueForReview(String userId) async {
    // This would check spaced repetition schedule
    // For now, return recent vocabulary
    try {
      final querySnapshot = await firestoreDataSource.queryCollection(
        AppConstants.vocabularyCollection,
        limit: 20,
      );
      
      return querySnapshot.docs
          .map((doc) => VocabularyModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Lấy từ vựng cần ôn thất bại: $e');
    }
  }
  
  @override
  Future<void> markAsLearned(String userId, String vocabId) async {
    try {
      // Save to user progress
      final progressData = {
        'userId': userId,
        'vocabId': vocabId,
        'learned': true,
        'learnedAt': DateTime.now(),
        'nextReviewDate': DateTime.now().add(const Duration(days: 1)),
        'interval': 1,
      };
      
      await firestoreDataSource.addDocument(
        'user_vocabulary_progress',
        progressData,
      );
    } catch (e) {
      throw Exception('Đánh dấu đã học thất bại: $e');
    }
  }
  
  @override
  Future<void> updateSpacedRepetition(
    String userId,
    String vocabId,
    bool isCorrect,
  ) async {
    try {
      // Implement spaced repetition algorithm
      // Increase or decrease interval based on correctness
      final newInterval = isCorrect ? 2 : 1; // Simplified
      final nextReviewDate = DateTime.now().add(Duration(days: newInterval));
      
      final progressData = {
        'lastReviewedAt': DateTime.now(),
        'nextReviewDate': nextReviewDate,
        'interval': newInterval,
        'correctCount': isCorrect ? 1 : 0,
      };
      
      // Update user vocabulary progress
      await firestoreDataSource.updateDocument(
        'user_vocabulary_progress',
        '${userId}_$vocabId',
        progressData,
      );
    } catch (e) {
      throw Exception('Cập nhật spaced repetition thất bại: $e');
    }
  }
}

