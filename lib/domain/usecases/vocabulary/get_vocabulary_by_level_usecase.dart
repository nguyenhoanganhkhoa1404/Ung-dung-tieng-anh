import '../../entities/vocabulary_entity.dart';
import '../../repositories/vocabulary_repository.dart';

class GetVocabularyByLevelUseCase {
  final VocabularyRepository repository;
  
  GetVocabularyByLevelUseCase(this.repository);
  
  Future<List<VocabularyEntity>> call(String level) async {
    return await repository.getVocabularyByLevel(level);
  }
}

