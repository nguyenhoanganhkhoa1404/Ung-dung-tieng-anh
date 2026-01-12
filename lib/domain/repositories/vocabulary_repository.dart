import '../entities/vocabulary_entity.dart';

abstract class VocabularyRepository {
  Future<List<VocabularyEntity>> getVocabularyByLevel(String level);
  Future<VocabularyEntity> getVocabularyById(String vocabId);
  Future<List<VocabularyEntity>> searchVocabulary(String query);
  Future<List<VocabularyEntity>> getDueForReview(String userId);
  Future<void> markAsLearned(String userId, String vocabId);
  Future<void> updateSpacedRepetition(String userId, String vocabId, bool isCorrect);
}

