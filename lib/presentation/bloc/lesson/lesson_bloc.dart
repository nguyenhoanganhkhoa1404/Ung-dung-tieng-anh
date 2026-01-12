import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/lesson_entity.dart';
import '../../../domain/repositories/lesson_repository.dart';

// Events
abstract class LessonEvent extends Equatable {
  const LessonEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadLessonsByLevel extends LessonEvent {
  final String level;
  
  const LoadLessonsByLevel(this.level);
  
  @override
  List<Object?> get props => [level];
}

class LoadLessonsByType extends LessonEvent {
  final LessonType type;
  
  const LoadLessonsByType(this.type);
  
  @override
  List<Object?> get props => [type];
}

class LoadLessonById extends LessonEvent {
  final String lessonId;
  
  const LoadLessonById(this.lessonId);
  
  @override
  List<Object?> get props => [lessonId];
}

class LoadRecommendedLessons extends LessonEvent {
  final String userId;
  
  const LoadRecommendedLessons(this.userId);
  
  @override
  List<Object?> get props => [userId];
}

// States
abstract class LessonState extends Equatable {
  const LessonState();
  
  @override
  List<Object?> get props => [];
}

class LessonInitial extends LessonState {}

class LessonLoading extends LessonState {}

class LessonsLoaded extends LessonState {
  final List<LessonEntity> lessons;
  
  const LessonsLoaded(this.lessons);
  
  @override
  List<Object?> get props => [lessons];
}

class LessonDetailLoaded extends LessonState {
  final LessonEntity lesson;
  
  const LessonDetailLoaded(this.lesson);
  
  @override
  List<Object?> get props => [lesson];
}

class LessonError extends LessonState {
  final String message;
  
  const LessonError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// Bloc
class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final LessonRepository lessonRepository;
  
  LessonBloc({required this.lessonRepository}) : super(LessonInitial()) {
    on<LoadLessonsByLevel>(_onLoadLessonsByLevel);
    on<LoadLessonsByType>(_onLoadLessonsByType);
    on<LoadLessonById>(_onLoadLessonById);
    on<LoadRecommendedLessons>(_onLoadRecommendedLessons);
  }
  
  Future<void> _onLoadLessonsByLevel(
    LoadLessonsByLevel event,
    Emitter<LessonState> emit,
  ) async {
    emit(LessonLoading());
    
    try {
      final lessons = await lessonRepository.getLessonsByLevel(event.level);
      emit(LessonsLoaded(lessons));
    } catch (e) {
      emit(LessonError(e.toString()));
    }
  }
  
  Future<void> _onLoadLessonsByType(
    LoadLessonsByType event,
    Emitter<LessonState> emit,
  ) async {
    emit(LessonLoading());
    
    try {
      final lessons = await lessonRepository.getLessonsByType(event.type);
      emit(LessonsLoaded(lessons));
    } catch (e) {
      emit(LessonError(e.toString()));
    }
  }
  
  Future<void> _onLoadLessonById(
    LoadLessonById event,
    Emitter<LessonState> emit,
  ) async {
    emit(LessonLoading());
    
    try {
      final lesson = await lessonRepository.getLessonById(event.lessonId);
      emit(LessonDetailLoaded(lesson));
    } catch (e) {
      emit(LessonError(e.toString()));
    }
  }
  
  Future<void> _onLoadRecommendedLessons(
    LoadRecommendedLessons event,
    Emitter<LessonState> emit,
  ) async {
    emit(LessonLoading());
    
    try {
      final lessons = await lessonRepository.getRecommendedLessons(event.userId);
      emit(LessonsLoaded(lessons));
    } catch (e) {
      emit(LessonError(e.toString()));
    }
  }
}

