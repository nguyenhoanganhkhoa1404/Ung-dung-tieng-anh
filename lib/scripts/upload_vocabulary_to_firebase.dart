import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import '../firebase_options.dart';
import '../data/datasources/local/vocabulary_seed_data.dart';

/// Script để upload 1000+ từ vựng lên Firebase Firestore
/// Chạy file này 1 lần để populate database
/// 
/// CÁCH CHẠY:
/// flutter run lib/scripts/upload_vocabulary_to_firebase.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (with error handling for duplicate app)
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }
  } catch (e) {
    print('⚠️  Firebase already initialized or error: $e');
  }
  
  runApp(const VocabularyUploadApp());
}

class VocabularyUploadApp extends StatelessWidget {
  const VocabularyUploadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Vocabulary',
      home: const VocabularyUploadScreen(),
    );
  }
}

class VocabularyUploadScreen extends StatefulWidget {
  const VocabularyUploadScreen({super.key});

  @override
  State<VocabularyUploadScreen> createState() => _VocabularyUploadScreenState();
}

class _VocabularyUploadScreenState extends State<VocabularyUploadScreen> {
  bool _isUploading = false;
  String _status = 'Ready to upload';
  int _uploadedCount = 0;
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Auto-start upload so user doesn't need to click a button.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _uploadVocabulary();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Vocabulary to Firebase')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isUploading ? Icons.cloud_upload : Icons.cloud_done,
                size: 100,
                color: _isUploading ? Colors.blue : Colors.green,
              ),
              const SizedBox(height: 24),
              Text(
                _status,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Uploaded: $_uploadedCount words',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadVocabulary,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text(_isUploading ? 'Uploading...' : 'Re-run Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _uploadVocabulary() async {
    setState(() {
      _isUploading = true;
      _status = 'Uploading vocabulary...';
      _uploadedCount = 0;
    });
    
    try {
      final vocabularyData = _getComprehensiveVocabularyData();

      // Firestore batch limit is 500 => commit theo chunk để không bị lỗi.
      const int chunkSize = 450;
      int uploaded = 0;

      for (int start = 0; start < vocabularyData.length; start += chunkSize) {
        final end = (start + chunkSize > vocabularyData.length)
            ? vocabularyData.length
            : start + chunkSize;

        final batch = _firestore.batch();

        for (int i = start; i < end; i++) {
          final word = vocabularyData[i];
          final docId = _docIdForWord(word);
          final docRef = _firestore.collection('vocabulary').doc(docId);

          // set(..., merge: true) => chạy lại không bị trùng document (idempotent)
          batch.set(
            docRef,
            {
              ...word,
              'createdAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
        }

        await batch.commit();
        uploaded += (end - start);

        setState(() {
          _uploadedCount = uploaded;
          _status = 'Uploaded $_uploadedCount / ${vocabularyData.length} words...';
        });
      }
      
      setState(() {
        _isUploading = false;
        _status = 'Successfully uploaded ${vocabularyData.length} words!';
      });

      // Auto-exit after success (useful for scripting)
      await Future.delayed(const Duration(seconds: 2));
      exit(0);
      
    } catch (e) {
      setState(() {
        _isUploading = false;
        _status = 'Error: $e';
      });
    }
  }
  
  /// Comprehensive vocabulary data - 1000+ words
  List<Map<String, dynamic>> _getComprehensiveVocabularyData() {
    // Lấy seed data theo level (A1 -> C2) từ file `VocabularySeedData`
    return VocabularySeedData.vocabularyData;
  }

  String _docIdForWord(Map<String, dynamic> word) {
    final level = (word['level'] ?? 'A1').toString().trim().toUpperCase();
    final raw = (word['word'] ?? '').toString().trim().toLowerCase();
    final slug = raw.replaceAll(RegExp(r'\\s+'), '_').replaceAll(RegExp(r'[^a-z0-9_]+'), '');
    return '${level}_$slug';
  }
  
  // NOTE: Các hàm generate cũ vẫn giữ lại để tham khảo, nhưng không còn dùng khi upload.
  // ignore: unused_element
  Map<String, dynamic> _generateBasicNoun(int index) {
    final nouns = [
      {'word': 'apple', 'meaning': 'quả táo', 'ipa': '/ˈæp.əl/'},
      {'word': 'book', 'meaning': 'cuốn sách', 'ipa': '/bʊk/'},
      {'word': 'car', 'meaning': 'xe hơi', 'ipa': '/kɑːr/'},
      {'word': 'dog', 'meaning': 'con chó', 'ipa': '/dɔːɡ/'},
      {'word': 'cat', 'meaning': 'con mèo', 'ipa': '/kæt/'},
      {'word': 'house', 'meaning': 'ngôi nhà', 'ipa': '/haʊs/'},
      {'word': 'water', 'meaning': 'nước', 'ipa': '/ˈwɔːtə(r)/'},
      {'word': 'food', 'meaning': 'thức ăn', 'ipa': '/fuːd/'},
      {'word': 'school', 'meaning': 'trường học', 'ipa': '/skuːl/'},
      {'word': 'teacher', 'meaning': 'giáo viên', 'ipa': '/ˈtiːtʃə(r)/'},
      {'word': 'student', 'meaning': 'học sinh', 'ipa': '/ˈstuːdnt/'},
      {'word': 'friend', 'meaning': 'bạn bè', 'ipa': '/frend/'},
      {'word': 'family', 'meaning': 'gia đình', 'ipa': '/ˈfæməli/'},
      {'word': 'mother', 'meaning': 'mẹ', 'ipa': '/ˈmʌðə(r)/'},
      {'word': 'father', 'meaning': 'bố', 'ipa': '/ˈfɑːðə(r)/'},
      {'word': 'sister', 'meaning': 'chị/em gái', 'ipa': '/ˈsɪstə(r)/'},
      {'word': 'brother', 'meaning': 'anh/em trai', 'ipa': '/ˈbrʌðə(r)/'},
      {'word': 'phone', 'meaning': 'điện thoại', 'ipa': '/fəʊn/'},
      {'word': 'computer', 'meaning': 'máy tính', 'ipa': '/kəmˈpjuːtə(r)/'},
      {'word': 'table', 'meaning': 'cái bàn', 'ipa': '/ˈteɪbl/'},
    ];
    
    final data = nouns[index % nouns.length];
    return {
      'word': data['word'],
      'pronunciation': data['ipa'],
      'meaning': data['meaning'],
      'partOfSpeech': 'noun',
      'level': 'A1',
      'example': 'I have a ${data['word']}.',
      'exampleTranslation': 'Tôi có ${data['meaning']}.',
      'synonyms': [],
      'antonyms': [],
    };
  }
  
  // ignore: unused_element
  Map<String, dynamic> _generateBasicVerb(int index) {
    final verbs = [
      {'word': 'run', 'meaning': 'chạy', 'ipa': '/rʌn/'},
      {'word': 'walk', 'meaning': 'đi bộ', 'ipa': '/wɔːk/'},
      {'word': 'eat', 'meaning': 'ăn', 'ipa': '/iːt/'},
      {'word': 'drink', 'meaning': 'uống', 'ipa': '/drɪŋk/'},
      {'word': 'sleep', 'meaning': 'ngủ', 'ipa': '/sliːp/'},
      {'word': 'read', 'meaning': 'đọc', 'ipa': '/riːd/'},
      {'word': 'write', 'meaning': 'viết', 'ipa': '/raɪt/'},
      {'word': 'speak', 'meaning': 'nói', 'ipa': '/spiːk/'},
      {'word': 'listen', 'meaning': 'nghe', 'ipa': '/ˈlɪsn/'},
      {'word': 'watch', 'meaning': 'xem', 'ipa': '/wɒtʃ/'},
      {'word': 'play', 'meaning': 'chơi', 'ipa': '/pleɪ/'},
      {'word': 'work', 'meaning': 'làm việc', 'ipa': '/wɜːk/'},
      {'word': 'study', 'meaning': 'học', 'ipa': '/ˈstʌdi/'},
      {'word': 'go', 'meaning': 'đi', 'ipa': '/ɡəʊ/'},
      {'word': 'come', 'meaning': 'đến', 'ipa': '/kʌm/'},
    ];
    
    final data = verbs[index % verbs.length];
    return {
      'word': data['word'],
      'pronunciation': data['ipa'],
      'meaning': data['meaning'],
      'partOfSpeech': 'verb',
      'level': 'A1',
      'example': 'I ${data['word']} every day.',
      'exampleTranslation': 'Tôi ${data['meaning']} mỗi ngày.',
      'synonyms': [],
      'antonyms': [],
    };
  }
  
  // ignore: unused_element
  Map<String, dynamic> _generateBasicAdjective(int index) {
    final adjectives = [
      {'word': 'big', 'meaning': 'to, lớn', 'ipa': '/bɪɡ/'},
      {'word': 'small', 'meaning': 'nhỏ', 'ipa': '/smɔːl/'},
      {'word': 'good', 'meaning': 'tốt', 'ipa': '/ɡʊd/'},
      {'word': 'bad', 'meaning': 'xấu', 'ipa': '/bæd/'},
      {'word': 'happy', 'meaning': 'vui', 'ipa': '/ˈhæpi/'},
      {'word': 'sad', 'meaning': 'buồn', 'ipa': '/sæd/'},
      {'word': 'beautiful', 'meaning': 'đẹp', 'ipa': '/ˈbjuːtɪfl/'},
      {'word': 'ugly', 'meaning': 'xấu xí', 'ipa': '/ˈʌɡli/'},
      {'word': 'hot', 'meaning': 'nóng', 'ipa': '/hɒt/'},
      {'word': 'cold', 'meaning': 'lạnh', 'ipa': '/kəʊld/'},
      {'word': 'new', 'meaning': 'mới', 'ipa': '/njuː/'},
      {'word': 'old', 'meaning': 'cũ', 'ipa': '/əʊld/'},
      {'word': 'fast', 'meaning': 'nhanh', 'ipa': '/fɑːst/'},
      {'word': 'slow', 'meaning': 'chậm', 'ipa': '/sləʊ/'},
    ];
    
    final data = adjectives[index % adjectives.length];
    return {
      'word': data['word'],
      'pronunciation': data['ipa'],
      'meaning': data['meaning'],
      'partOfSpeech': 'adjective',
      'level': 'A1',
      'example': 'This is ${data['word']}.',
      'exampleTranslation': 'Cái này ${data['meaning']}.',
      'synonyms': [],
      'antonyms': [],
    };
  }
  
  // ignore: unused_element
  Map<String, dynamic> _generateBasicAdverb(int index) {
    final adverbs = [
      {'word': 'quickly', 'meaning': 'nhanh chóng', 'ipa': '/ˈkwɪkli/'},
      {'word': 'slowly', 'meaning': 'chậm chạp', 'ipa': '/ˈsləʊli/'},
      {'word': 'carefully', 'meaning': 'cẩn thận', 'ipa': '/ˈkeəfəli/'},
      {'word': 'easily', 'meaning': 'dễ dàng', 'ipa': '/ˈiːzɪli/'},
      {'word': 'happily', 'meaning': 'vui vẻ', 'ipa': '/ˈhæpɪli/'},
    ];
    
    final data = adverbs[index % adverbs.length];
    return {
      'word': data['word'],
      'pronunciation': data['ipa'],
      'meaning': data['meaning'],
      'partOfSpeech': 'adverb',
      'level': 'A1',
      'example': 'He runs ${data['word']}.',
      'exampleTranslation': 'Anh ấy chạy ${data['meaning']}.',
      'synonyms': [],
      'antonyms': [],
    };
  }
  
  // ignore: unused_element
  Map<String, dynamic> _generateA2Word(int index) {
    final words = [
      {'word': 'achieve', 'meaning': 'đạt được', 'ipa': '/əˈtʃiːv/', 'pos': 'verb'},
      {'word': 'believe', 'meaning': 'tin tưởng', 'ipa': '/bɪˈliːv/', 'pos': 'verb'},
      {'word': 'create', 'meaning': 'tạo ra', 'ipa': '/kriˈeɪt/', 'pos': 'verb'},
      {'word': 'develop', 'meaning': 'phát triển', 'ipa': '/dɪˈveləp/', 'pos': 'verb'},
      {'word': 'important', 'meaning': 'quan trọng', 'ipa': '/ɪmˈpɔːtnt/', 'pos': 'adjective'},
    ];
    
    final data = words[index % words.length];
    return {
      'word': data['word'],
      'pronunciation': data['ipa'],
      'meaning': data['meaning'],
      'partOfSpeech': data['pos'],
      'level': 'A2',
      'example': 'You need to ${data['word']}.',
      'exampleTranslation': 'Bạn cần ${data['meaning']}.',
      'synonyms': [],
      'antonyms': [],
    };
  }
  
  // ignore: unused_element
  Map<String, dynamic> _generateA2Phrase(int index) {
    // Similar pattern for A2 phrases
    return _generateA2Word(index);
  }
  
  // ignore: unused_element
  Map<String, dynamic> _generateB1Word(int index) {
    final words = [
      {'word': 'accomplish', 'meaning': 'hoàn thành', 'ipa': '/əˈkʌmplɪʃ/', 'pos': 'verb'},
      {'word': 'analyze', 'meaning': 'phân tích', 'ipa': '/ˈænəlaɪz/', 'pos': 'verb'},
      {'word': 'complex', 'meaning': 'phức tạp', 'ipa': '/ˈkɒmpleks/', 'pos': 'adjective'},
      {'word': 'significant', 'meaning': 'đáng kể', 'ipa': '/sɪɡˈnɪfɪkənt/', 'pos': 'adjective'},
    ];
    
    final data = words[index % words.length];
    return {
      'word': data['word'],
      'pronunciation': data['ipa'],
      'meaning': data['meaning'],
      'partOfSpeech': data['pos'],
      'level': 'B1',
      'example': 'It is ${data['word']}.',
      'exampleTranslation': 'Nó ${data['meaning']}.',
      'synonyms': [],
      'antonyms': [],
    };
  }
  
  // ignore: unused_element
  Map<String, dynamic> _generateB1Expression(int index) {
    return _generateB1Word(index);
  }
  
  // ignore: unused_element
  Map<String, dynamic> _generateB2Word(int index) {
    final words = [
      {'word': 'comprehend', 'meaning': 'thấu hiểu', 'ipa': '/ˌkɒmprɪˈhend/', 'pos': 'verb'},
      {'word': 'sophisticated', 'meaning': 'tinh vi', 'ipa': '/səˈfɪstɪkeɪtɪd/', 'pos': 'adjective'},
      {'word': 'substantial', 'meaning': 'đáng kể', 'ipa': '/səbˈstænʃl/', 'pos': 'adjective'},
    ];
    
    final data = words[index % words.length];
    return {
      'word': data['word'],
      'pronunciation': data['ipa'],
      'meaning': data['meaning'],
      'partOfSpeech': data['pos'],
      'level': 'B2',
      'example': 'This is very ${data['word']}.',
      'exampleTranslation': 'Điều này rất ${data['meaning']}.',
      'synonyms': [],
      'antonyms': [],
    };
  }
}

