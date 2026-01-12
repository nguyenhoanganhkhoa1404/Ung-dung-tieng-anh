import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/vocabulary_entity.dart';
import '../../../domain/repositories/vocabulary_repository.dart';

// Events
abstract class VocabularyEvent extends Equatable {
  const VocabularyEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadVocabularyByLevel extends VocabularyEvent {
  final String level;
  
  const LoadVocabularyByLevel(this.level);
  
  @override
  List<Object?> get props => [level];
}

class SearchVocabulary extends VocabularyEvent {
  final String query;
  
  const SearchVocabulary(this.query);
  
  @override
  List<Object?> get props => [query];
}

class MarkVocabularyAsLearned extends VocabularyEvent {
  final String userId;
  final String vocabId;
  
  const MarkVocabularyAsLearned(this.userId, this.vocabId);
  
  @override
  List<Object?> get props => [userId, vocabId];
}

// States
abstract class VocabularyState extends Equatable {
  const VocabularyState();
  
  @override
  List<Object?> get props => [];
}

class VocabularyInitial extends VocabularyState {}

class VocabularyLoading extends VocabularyState {}

class VocabularyLoaded extends VocabularyState {
  final List<VocabularyEntity> vocabulary;
  
  const VocabularyLoaded(this.vocabulary);
  
  @override
  List<Object?> get props => [vocabulary];
}

class VocabularyError extends VocabularyState {
  final String message;
  
  const VocabularyError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// Bloc
class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  final VocabularyRepository vocabularyRepository;
  
  VocabularyBloc({required this.vocabularyRepository}) : super(VocabularyInitial()) {
    on<LoadVocabularyByLevel>(_onLoadVocabularyByLevel);
    on<SearchVocabulary>(_onSearchVocabulary);
    on<MarkVocabularyAsLearned>(_onMarkAsLearned);
  }
  
  Future<void> _onLoadVocabularyByLevel(
    LoadVocabularyByLevel event,
    Emitter<VocabularyState> emit,
  ) async {
    emit(VocabularyLoading());
    
    try {
      final vocabulary = await vocabularyRepository.getVocabularyByLevel(event.level);
      emit(VocabularyLoaded(vocabulary));
    } catch (e) {
      emit(VocabularyError(e.toString()));
    }
  }
  
  Future<void> _onSearchVocabulary(
    SearchVocabulary event,
    Emitter<VocabularyState> emit,
  ) async {
    emit(VocabularyLoading());
    
    try {
      final vocabulary = await vocabularyRepository.searchVocabulary(event.query);
      emit(VocabularyLoaded(vocabulary));
    } catch (e) {
      emit(VocabularyError(e.toString()));
    }
  }
  
  Future<void> _onMarkAsLearned(
    MarkVocabularyAsLearned event,
    Emitter<VocabularyState> emit,
  ) async {
    try {
      await vocabularyRepository.markAsLearned(event.userId, event.vocabId);
    } catch (e) {
      emit(VocabularyError(e.toString()));
    }
  }
}

