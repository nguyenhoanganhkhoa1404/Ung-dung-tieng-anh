import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/firebase_options.dart';

/// Script upload vocabulary với UI và progress tracking
/// Chạy: flutter run -d windows -t upload_vocab_improved.dart

void main() async {
  runApp(const VocabularyUploadApp());
}

class VocabularyUploadApp extends StatelessWidget {
  const VocabularyUploadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Vocabulary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const UploadPage(),
    );
  }
}

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool _isUploading = false;
  bool _isCompleted = false;
  int _currentIndex = 0;
  int _successCount = 0;
  int _failedCount = 0;
  String _currentWord = '';
  List<String> _logs = [];

  final List<Map<String, dynamic>> vocabulary = [
    // === NOUNS (Danh từ) ===
    {'word': 'apple', 'meaning': 'quả táo', 'pronunciation': '/ˈæp.əl/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'I eat an apple every day.', 'exampleTranslation': 'Tôi ăn một quả táo mỗi ngày.', 'synonyms': [], 'antonyms': []},
    {'word': 'book', 'meaning': 'cuốn sách', 'pronunciation': '/bʊk/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'I am reading a book.', 'exampleTranslation': 'Tôi đang đọc một cuốn sách.', 'synonyms': [], 'antonyms': []},
    {'word': 'car', 'meaning': 'xe hơi', 'pronunciation': '/kɑːr/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'This is my car.', 'exampleTranslation': 'Đây là xe của tôi.', 'synonyms': ['automobile', 'vehicle'], 'antonyms': []},
    {'word': 'dog', 'meaning': 'con chó', 'pronunciation': '/dɔːɡ/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'I have a dog.', 'exampleTranslation': 'Tôi có một con chó.', 'synonyms': ['puppy'], 'antonyms': ['cat']},
    {'word': 'cat', 'meaning': 'con mèo', 'pronunciation': '/kæt/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'The cat is sleeping.', 'exampleTranslation': 'Con mèo đang ngủ.', 'synonyms': ['kitten'], 'antonyms': ['dog']},
    {'word': 'house', 'meaning': 'ngôi nhà', 'pronunciation': '/haʊs/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'I live in a big house.', 'exampleTranslation': 'Tôi sống trong một ngôi nhà lớn.', 'synonyms': ['home'], 'antonyms': []},
    {'word': 'water', 'meaning': 'nước', 'pronunciation': '/ˈwɔːtə/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'I drink water every day.', 'exampleTranslation': 'Tôi uống nước mỗi ngày.', 'synonyms': [], 'antonyms': []},
    {'word': 'food', 'meaning': 'thức ăn', 'pronunciation': '/fuːd/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'This food is delicious.', 'exampleTranslation': 'Thức ăn này ngon.', 'synonyms': ['meal'], 'antonyms': []},
    {'word': 'school', 'meaning': 'trường học', 'pronunciation': '/skuːl/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'I go to school every day.', 'exampleTranslation': 'Tôi đi học mỗi ngày.', 'synonyms': [], 'antonyms': []},
    {'word': 'teacher', 'meaning': 'giáo viên', 'pronunciation': '/ˈtiːtʃə/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'My teacher is very kind.', 'exampleTranslation': 'Giáo viên của tôi rất tốt bụng.', 'synonyms': ['instructor'], 'antonyms': ['student']},
    {'word': 'student', 'meaning': 'học sinh', 'pronunciation': '/ˈstuːdnt/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'I am a student.', 'exampleTranslation': 'Tôi là học sinh.', 'synonyms': ['pupil'], 'antonyms': ['teacher']},
    {'word': 'friend', 'meaning': 'bạn bè', 'pronunciation': '/frend/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'She is my best friend.', 'exampleTranslation': 'Cô ấy là bạn thân của tôi.', 'synonyms': ['buddy'], 'antonyms': ['enemy']},
    {'word': 'family', 'meaning': 'gia đình', 'pronunciation': '/ˈfæməli/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'I love my family.', 'exampleTranslation': 'Tôi yêu gia đình mình.', 'synonyms': [], 'antonyms': []},
    {'word': 'mother', 'meaning': 'mẹ', 'pronunciation': '/ˈmʌðə/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'My mother cooks dinner.', 'exampleTranslation': 'Mẹ tôi nấu bữa tối.', 'synonyms': ['mom', 'mama'], 'antonyms': ['father']},
    {'word': 'father', 'meaning': 'bố', 'pronunciation': '/ˈfɑːðə/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'My father works hard.', 'exampleTranslation': 'Bố tôi làm việc chăm chỉ.', 'synonyms': ['dad', 'papa'], 'antonyms': ['mother']},
    {'word': 'sister', 'meaning': 'chị/em gái', 'pronunciation': '/ˈsɪstə/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'My sister is younger than me.', 'exampleTranslation': 'Em gái tôi nhỏ hơn tôi.', 'synonyms': [], 'antonyms': ['brother']},
    {'word': 'brother', 'meaning': 'anh/em trai', 'pronunciation': '/ˈbrʌðə/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'My brother plays soccer.', 'exampleTranslation': 'Anh tôi chơi bóng đá.', 'synonyms': [], 'antonyms': ['sister']},
    {'word': 'phone', 'meaning': 'điện thoại', 'pronunciation': '/fəʊn/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'I use my phone every day.', 'exampleTranslation': 'Tôi dùng điện thoại mỗi ngày.', 'synonyms': ['mobile'], 'antonyms': []},
    {'word': 'computer', 'meaning': 'máy tính', 'pronunciation': '/kəmˈpjuːtə/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'I work on my computer.', 'exampleTranslation': 'Tôi làm việc trên máy tính.', 'synonyms': ['laptop'], 'antonyms': []},
    {'word': 'table', 'meaning': 'cái bàn', 'pronunciation': '/ˈteɪbl/', 'partOfSpeech': 'noun', 'level': 'A1', 'example': 'The book is on the table.', 'exampleTranslation': 'Cuốn sách ở trên bàn.', 'synonyms': ['desk'], 'antonyms': []},
    
    // === VERBS (Động từ) ===
    {'word': 'run', 'meaning': 'chạy', 'pronunciation': '/rʌn/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I run every morning.', 'exampleTranslation': 'Tôi chạy mỗi sáng.', 'synonyms': ['jog'], 'antonyms': ['walk']},
    {'word': 'walk', 'meaning': 'đi bộ', 'pronunciation': '/wɔːk/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I walk to school.', 'exampleTranslation': 'Tôi đi bộ đến trường.', 'synonyms': ['stroll'], 'antonyms': ['run']},
    {'word': 'eat', 'meaning': 'ăn', 'pronunciation': '/iːt/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I eat breakfast at 7 AM.', 'exampleTranslation': 'Tôi ăn sáng lúc 7 giờ.', 'synonyms': ['consume'], 'antonyms': []},
    {'word': 'drink', 'meaning': 'uống', 'pronunciation': '/drɪŋk/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I drink water.', 'exampleTranslation': 'Tôi uống nước.', 'synonyms': ['sip'], 'antonyms': []},
    {'word': 'sleep', 'meaning': 'ngủ', 'pronunciation': '/sliːp/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I sleep 8 hours a day.', 'exampleTranslation': 'Tôi ngủ 8 tiếng mỗi ngày.', 'synonyms': ['rest'], 'antonyms': ['wake']},
    {'word': 'read', 'meaning': 'đọc', 'pronunciation': '/riːd/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I read books every day.', 'exampleTranslation': 'Tôi đọc sách mỗi ngày.', 'synonyms': [], 'antonyms': ['write']},
    {'word': 'write', 'meaning': 'viết', 'pronunciation': '/raɪt/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I write in my diary.', 'exampleTranslation': 'Tôi viết nhật ký.', 'synonyms': [], 'antonyms': ['read']},
    {'word': 'speak', 'meaning': 'nói', 'pronunciation': '/spiːk/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I speak English.', 'exampleTranslation': 'Tôi nói tiếng Anh.', 'synonyms': ['talk'], 'antonyms': ['listen']},
    {'word': 'listen', 'meaning': 'nghe', 'pronunciation': '/ˈlɪsn/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I listen to music.', 'exampleTranslation': 'Tôi nghe nhạc.', 'synonyms': ['hear'], 'antonyms': ['speak']},
    {'word': 'watch', 'meaning': 'xem', 'pronunciation': '/wɒtʃ/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I watch TV at night.', 'exampleTranslation': 'Tôi xem TV vào buổi tối.', 'synonyms': ['view'], 'antonyms': []},
    {'word': 'play', 'meaning': 'chơi', 'pronunciation': '/pleɪ/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I play soccer with friends.', 'exampleTranslation': 'Tôi chơi bóng đá với bạn bè.', 'synonyms': [], 'antonyms': ['work']},
    {'word': 'work', 'meaning': 'làm việc', 'pronunciation': '/wɜːk/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I work hard every day.', 'exampleTranslation': 'Tôi làm việc chăm chỉ mỗi ngày.', 'synonyms': ['labor'], 'antonyms': ['play']},
    {'word': 'study', 'meaning': 'học', 'pronunciation': '/ˈstʌdi/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I study English.', 'exampleTranslation': 'Tôi học tiếng Anh.', 'synonyms': ['learn'], 'antonyms': []},
    {'word': 'go', 'meaning': 'đi', 'pronunciation': '/ɡəʊ/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'I go to work.', 'exampleTranslation': 'Tôi đi làm.', 'synonyms': ['move'], 'antonyms': ['come', 'stay']},
    {'word': 'come', 'meaning': 'đến', 'pronunciation': '/kʌm/', 'partOfSpeech': 'verb', 'level': 'A1', 'example': 'Come here, please.', 'exampleTranslation': 'Hãy đến đây.', 'synonyms': ['arrive'], 'antonyms': ['go', 'leave']},
    
    // === ADJECTIVES (Tính từ) ===
    {'word': 'big', 'meaning': 'to, lớn', 'pronunciation': '/bɪɡ/', 'partOfSpeech': 'adjective', 'level': 'A1', 'example': 'This is a big house.', 'exampleTranslation': 'Đây là một ngôi nhà lớn.', 'synonyms': ['large', 'huge'], 'antonyms': ['small']},
    {'word': 'small', 'meaning': 'nhỏ', 'pronunciation': '/smɔːl/', 'partOfSpeech': 'adjective', 'level': 'A1', 'example': 'This is a small car.', 'exampleTranslation': 'Đây là một chiếc xe nhỏ.', 'synonyms': ['tiny', 'little'], 'antonyms': ['big']},
    {'word': 'good', 'meaning': 'tốt', 'pronunciation': '/ɡʊd/', 'partOfSpeech': 'adjective', 'level': 'A1', 'example': 'This is a good book.', 'exampleTranslation': 'Đây là một cuốn sách hay.', 'synonyms': ['great', 'nice'], 'antonyms': ['bad']},
    {'word': 'bad', 'meaning': 'xấu', 'pronunciation': '/bæd/', 'partOfSpeech': 'adjective', 'level': 'A1', 'example': 'This is bad weather.', 'exampleTranslation': 'Đây là thời tiết xấu.', 'synonyms': ['poor', 'terrible'], 'antonyms': ['good']},
    {'word': 'happy', 'meaning': 'vui vẻ', 'pronunciation': '/ˈhæpi/', 'partOfSpeech': 'adjective', 'level': 'A1', 'example': 'I am very happy today.', 'exampleTranslation': 'Tôi rất vui vẻ hôm nay.', 'synonyms': ['joyful', 'glad'], 'antonyms': ['sad']},
    {'word': 'sad', 'meaning': 'buồn', 'pronunciation': '/sæd/', 'partOfSpeech': 'adjective', 'level': 'A1', 'example': 'She looks sad.', 'exampleTranslation': 'Cô ấy trông buồn.', 'synonyms': ['unhappy'], 'antonyms': ['happy']},
    {'word': 'beautiful', 'meaning': 'đẹp', 'pronunciation': '/ˈbjuːtɪfl/', 'partOfSpeech': 'adjective', 'level': 'A1', 'example': 'She is beautiful.', 'exampleTranslation': 'Cô ấy đẹp.', 'synonyms': ['pretty', 'gorgeous'], 'antonyms': ['ugly']},
    {'word': 'hot', 'meaning': 'nóng', 'pronunciation': '/hɒt/', 'partOfSpeech': 'adjective', 'level': 'A1', 'example': 'It is very hot today.', 'exampleTranslation': 'Hôm nay rất nóng.', 'synonyms': ['warm'], 'antonyms': ['cold']},
    {'word': 'cold', 'meaning': 'lạnh', 'pronunciation': '/kəʊld/', 'partOfSpeech': 'adjective', 'level': 'A1', 'example': 'The water is cold.', 'exampleTranslation': 'Nước lạnh.', 'synonyms': ['chilly'], 'antonyms': ['hot']},
    {'word': 'new', 'meaning': 'mới', 'pronunciation': '/njuː/', 'partOfSpeech': 'adjective', 'level': 'A1', 'example': 'I bought a new phone.', 'exampleTranslation': 'Tôi mua một cái điện thoại mới.', 'synonyms': ['fresh'], 'antonyms': ['old']},
    {'word': 'old', 'meaning': 'cũ', 'pronunciation': '/əʊld/', 'partOfSpeech': 'adjective', 'level': 'A1', 'example': 'This is an old book.', 'exampleTranslation': 'Đây là một cuốn sách cũ.', 'synonyms': ['ancient'], 'antonyms': ['new']},
    
    // === COMMON WORDS ===
    {'word': 'goodbye', 'meaning': 'tạm biệt', 'pronunciation': '/ɡʊdˈbaɪ/', 'partOfSpeech': 'interjection', 'level': 'A1', 'example': 'Goodbye, see you tomorrow!', 'exampleTranslation': 'Tạm biệt, hẹn gặp lại ngày mai!', 'synonyms': ['bye', 'farewell'], 'antonyms': ['hello']},
    {'word': 'yes', 'meaning': 'có, đúng', 'pronunciation': '/jes/', 'partOfSpeech': 'adverb', 'level': 'A1', 'example': 'Yes, I agree.', 'exampleTranslation': 'Có, tôi đồng ý.', 'synonyms': ['yeah'], 'antonyms': ['no']},
    {'word': 'no', 'meaning': 'không', 'pronunciation': '/nəʊ/', 'partOfSpeech': 'adverb', 'level': 'A1', 'example': 'No, I do not want.', 'exampleTranslation': 'Không, tôi không muốn.', 'synonyms': ['nope'], 'antonyms': ['yes']},
    {'word': 'please', 'meaning': 'làm ơn', 'pronunciation': '/pliːz/', 'partOfSpeech': 'adverb', 'level': 'A1', 'example': 'Please help me.', 'exampleTranslation': 'Làm ơn giúp tôi.', 'synonyms': [], 'antonyms': []},
    {'word': 'thank you', 'meaning': 'cảm ơn', 'pronunciation': '/θæŋk juː/', 'partOfSpeech': 'phrase', 'level': 'A1', 'example': 'Thank you for your help.', 'exampleTranslation': 'Cảm ơn sự giúp đỡ của bạn.', 'synonyms': ['thanks'], 'antonyms': []},
  ];

  void _addLog(String message) {
    setState(() {
      _logs.add(message);
      print(message); // Also print to console
    });
  }

  String _formatFirestoreError(Object e) {
    if (e is FirebaseException) {
      return 'FirebaseException(code=${e.code}, message=${e.message})';
    }
    return e.toString();
  }

  Future<void> _startUpload() async {
    setState(() {
      _isUploading = true;
      _isCompleted = false;
      _currentIndex = 0;
      _successCount = 0;
      _failedCount = 0;
      _logs.clear();
    });

    try {
      _addLog('🚀 Bắt đầu khởi tạo Firebase...');
      
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      
      _addLog('✅ Firebase đã kết nối');
      _addLog('🔗 projectId: ${Firebase.app().options.projectId}');
      _addLog('📚 Bắt đầu upload ${vocabulary.length} từ vựng...\n');

      final firestore = FirebaseFirestore.instance;

      for (var i = 0; i < vocabulary.length; i++) {
        setState(() {
          _currentIndex = i + 1;
          _currentWord = vocabulary[i]['word'] as String;
        });

        try {
          await firestore
              .collection('vocabulary')
              .add({
                ...vocabulary[i],
                'createdAt': FieldValue.serverTimestamp(),
              })
              .timeout(const Duration(seconds: 20));

          _addLog('✅ [${i + 1}/${vocabulary.length}] ${vocabulary[i]['word']}');
          
          setState(() {
            _successCount++;
          });

          // Small delay to avoid rate limiting
          await Future.delayed(const Duration(milliseconds: 100));
          
        } catch (e) {
          final formatted = _formatFirestoreError(e);
          _addLog('❌ [${i + 1}/${vocabulary.length}] ${vocabulary[i]['word']}: $formatted');
          setState(() {
            _failedCount++;
          });

          // Nếu bị chặn bởi Rules thì dừng sớm để khỏi "đứng yên" lâu.
          if (formatted.contains('permission-denied')) {
            _addLog(
              '⛔ Firestore Rules đang CHẶN ghi vào collection `vocabulary`.\n'
              'Vào Firebase Console → Firestore Database → Rules, tạm thời bật write cho /vocabulary rồi chạy lại.',
            );
            break;
          }
        }
      }

      setState(() {
        _isCompleted = true;
        _isUploading = false;
      });

      _addLog('\n${'=' * 50}');
      _addLog('🎉 HOÀN TẤT!');
      _addLog('✅ Thành công: $_successCount từ');
      if (_failedCount > 0) {
        _addLog('❌ Thất bại: $_failedCount từ');
      }
      _addLog('=' * 50);

    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      _addLog('\n❌ LỖI: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Vocabulary to Firebase'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isUploading && !_isCompleted)
              Column(
                children: [
                  const Icon(Icons.cloud_upload, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    'Sẵn sàng upload ${vocabulary.length} từ vựng',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _startUpload,
                    icon: const Icon(Icons.upload),
                    label: const Text('Bắt đầu Upload'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            
            if (_isUploading)
              Column(
                children: [
                  CircularProgressIndicator(
                    value: _currentIndex / vocabulary.length,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Đang upload: $_currentWord',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_currentIndex / ${vocabulary.length}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _currentIndex / vocabulary.length,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('✅ $_successCount  ', style: const TextStyle(color: Colors.green)),
                      Text('❌ $_failedCount', style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ],
              ),
            
            if (_isCompleted)
              Column(
                children: [
                  const Icon(Icons.check_circle, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  Text(
                    '🎉 Hoàn tất!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('✅ Thành công: $_successCount từ'),
                  if (_failedCount > 0)
                    Text('❌ Thất bại: $_failedCount từ'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isCompleted = false;
                        _logs.clear();
                      });
                    },
                    child: const Text('Upload lại'),
                  ),
                ],
              ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Logs:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Text(
                      _logs[index],
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

