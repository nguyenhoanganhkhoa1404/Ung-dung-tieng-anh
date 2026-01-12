import 'package:equatable/equatable.dart';

class VocabularyEntity extends Equatable {
  final String id;
  final String word;
  final String meaning;
  final String? pronunciation; // IPA
  final String? audioUrl;
  final String? imageUrl;
  final String? example;
  final String? exampleTranslation;
  final String partOfSpeech; // noun, verb, adjective, etc.
  final String level; // A1, A2, B1, B2, C1, C2
  final List<String> synonyms;
  final List<String> antonyms;
  final DateTime createdAt;
  
  const VocabularyEntity({
    required this.id,
    required this.word,
    required this.meaning,
    this.pronunciation,
    this.audioUrl,
    this.imageUrl,
    this.example,
    this.exampleTranslation,
    required this.partOfSpeech,
    required this.level,
    this.synonyms = const [],
    this.antonyms = const [],
    required this.createdAt,
  });
  
  @override
  List<Object?> get props => [
        id,
        word,
        meaning,
        pronunciation,
        audioUrl,
        imageUrl,
        example,
        exampleTranslation,
        partOfSpeech,
        level,
        synonyms,
        antonyms,
        createdAt,
      ];
}

