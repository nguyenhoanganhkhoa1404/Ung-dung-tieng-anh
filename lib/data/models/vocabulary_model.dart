import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/vocabulary_entity.dart';

class VocabularyModel extends VocabularyEntity {
  const VocabularyModel({
    required super.id,
    required super.word,
    required super.meaning,
    super.pronunciation,
    super.audioUrl,
    super.imageUrl,
    super.example,
    super.exampleTranslation,
    required super.partOfSpeech,
    required super.level,
    super.synonyms,
    super.antonyms,
    required super.createdAt,
  });
  
  factory VocabularyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final createdAtValue = data['createdAt'];
    final createdAt = createdAtValue is Timestamp ? createdAtValue.toDate() : DateTime.now();
    return VocabularyModel(
      id: doc.id,
      word: data['word'] ?? '',
      meaning: data['meaning'] ?? '',
      pronunciation: data['pronunciation'],
      audioUrl: data['audioUrl'],
      imageUrl: data['imageUrl'],
      example: data['example'],
      exampleTranslation: data['exampleTranslation'],
      partOfSpeech: data['partOfSpeech'] ?? '',
      level: data['level'] ?? 'A1',
      synonyms: List<String>.from(data['synonyms'] ?? []),
      antonyms: List<String>.from(data['antonyms'] ?? []),
      createdAt: createdAt,
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'word': word,
      'meaning': meaning,
      'pronunciation': pronunciation,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'example': example,
      'exampleTranslation': exampleTranslation,
      'partOfSpeech': partOfSpeech,
      'level': level,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory VocabularyModel.fromCache(Map<String, dynamic> data) {
    final createdAtMillis = data['createdAtMillis'];
    final createdAt = createdAtMillis is int
        ? DateTime.fromMillisecondsSinceEpoch(createdAtMillis)
        : DateTime.now();
    return VocabularyModel(
      id: (data['id'] ?? '').toString(),
      word: (data['word'] ?? '').toString(),
      meaning: (data['meaning'] ?? '').toString(),
      pronunciation: data['pronunciation']?.toString(),
      audioUrl: data['audioUrl']?.toString(),
      imageUrl: data['imageUrl']?.toString(),
      example: data['example']?.toString(),
      exampleTranslation: data['exampleTranslation']?.toString(),
      partOfSpeech: (data['partOfSpeech'] ?? '').toString(),
      level: (data['level'] ?? 'A1').toString(),
      synonyms: List<String>.from(data['synonyms'] ?? const []),
      antonyms: List<String>.from(data['antonyms'] ?? const []),
      createdAt: createdAt,
    );
  }

  /// Map dùng để lưu local (Hive). Hive không serialize được `Timestamp` của Firestore,
  /// nên mình lưu `createdAt` dạng millisecondsSinceEpoch (int).
  Map<String, dynamic> toCache() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'pronunciation': pronunciation,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'example': example,
      'exampleTranslation': exampleTranslation,
      'partOfSpeech': partOfSpeech,
      'level': level,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'createdAtMillis': createdAt.millisecondsSinceEpoch,
    };
  }
}

