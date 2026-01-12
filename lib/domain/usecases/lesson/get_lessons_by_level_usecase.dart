import '../../entities/lesson_entity.dart';
import '../../repositories/lesson_repository.dart';

class GetLessonsByLevelUseCase {
  final LessonRepository repository;
  
  GetLessonsByLevelUseCase(this.repository);
  
  Future<List<LessonEntity>> call(String level) async {
    return await repository.getLessonsByLevel(level);
  }
}

