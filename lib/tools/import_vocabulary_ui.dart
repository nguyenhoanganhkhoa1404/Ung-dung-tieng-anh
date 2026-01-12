import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../data/datasources/local/vocabulary_seed_data.dart';
import '../firebase_options.dart';

/// UI Tool để import từ vựng vào Firebase Firestore
/// 
/// Chạy bằng lệnh:
/// flutter run -t lib/tools/import_vocabulary_ui.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Lỗi khởi tạo Firebase: $e');
  }
  
  runApp(const ImportVocabularyApp());
}

class ImportVocabularyApp extends StatelessWidget {
  const ImportVocabularyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Import Vocabulary Tool',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ImportVocabularyPage(),
    );
  }
}

class ImportVocabularyPage extends StatefulWidget {
  const ImportVocabularyPage({super.key});

  @override
  State<ImportVocabularyPage> createState() => _ImportVocabularyPageState();
}

class _ImportVocabularyPageState extends State<ImportVocabularyPage> {
  bool _isImporting = false;
  double _progress = 0.0;
  String _statusMessage = 'Sẵn sàng import từ vựng';
  int _totalWords = 0;
  int _successCount = 0;
  int _skipCount = 0;
  int _errorCount = 0;
  String _currentWord = '';
  
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _totalWords = VocabularySeedData.vocabularyData.length;
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addLog(String message) {
    setState(() {
      _logs.add(message);
    });
    
    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _startImport() async {
    setState(() {
      _isImporting = true;
      _progress = 0.0;
      _successCount = 0;
      _skipCount = 0;
      _errorCount = 0;
      _logs.clear();
      _statusMessage = 'Đang bắt đầu import...';
    });
    
    _addLog('🚀 Bắt đầu import $_totalWords từ vựng vào Firebase Firestore');
    _addLog('━' * 60);
    
    final firestore = FirebaseFirestore.instance;
    final vocabularyCollection = firestore.collection('vocabulary');
    final vocabularyData = VocabularySeedData.vocabularyData;
    
    for (int i = 0; i < vocabularyData.length; i++) {
      if (!_isImporting) {
        _addLog('⏸️ Import đã bị dừng bởi người dùng');
        break;
      }
      
      final vocab = vocabularyData[i];
      final word = vocab['word'] as String;
      final docId = _createDocId(word, i);
      
      setState(() {
        _currentWord = word;
        _progress = (i + 1) / vocabularyData.length;
        _statusMessage = 'Đang import: ${i + 1}/$_totalWords';
      });
      
      try {
        final docRef = vocabularyCollection.doc(docId);
        final docSnapshot = await docRef.get();
        
        if (docSnapshot.exists) {
          setState(() => _skipCount++);
          if (i % 100 == 0) {
            _addLog('⏭️  Bỏ qua từ đã tồn tại: "$word"');
          }
          continue;
        }
        
        final data = {
          'word': vocab['word'],
          'pronunciation': vocab['pronunciation'] ?? '',
          'meaning': vocab['meaning'],
          'partOfSpeech': vocab['partOfSpeech'] ?? 'noun',
          'level': vocab['level'] ?? 'A1',
          'example': vocab['example'] ?? '',
          'exampleTranslation': vocab['exampleTranslation'] ?? '',
          'imageUrl': vocab['imageUrl'] ?? '',
          'audioUrl': '',
          'synonyms': List<String>.from(vocab['synonyms'] ?? []),
          'antonyms': List<String>.from(vocab['antonyms'] ?? []),
          'createdAt': FieldValue.serverTimestamp(),
        };
        
        await docRef.set(data);
        
        setState(() => _successCount++);
        
        if ((i + 1) % 100 == 0) {
          _addLog('✅ Đã import ${i + 1}/$_totalWords từ - "$word"');
        }
        
        // Delay nhỏ để tránh quá tải
        if ((i + 1) % 50 == 0) {
          await Future.delayed(const Duration(milliseconds: 300));
        }
        
      } catch (e) {
        setState(() => _errorCount++);
        _addLog('❌ Lỗi khi import "$word": $e');
      }
    }
    
    setState(() {
      _isImporting = false;
      _statusMessage = 'Hoàn thành!';
      _currentWord = '';
    });
    
    _addLog('━' * 60);
    _addLog('🎉 HOÀN THÀNH IMPORT!');
    _addLog('📊 Thống kê:');
    _addLog('  ✅ Thành công: $_successCount từ');
    _addLog('  ⏭️  Bỏ qua: $_skipCount từ');
    _addLog('  ❌ Lỗi: $_errorCount từ');
    _addLog('  📝 Tổng: $_totalWords từ');
  }

  void _stopImport() {
    setState(() {
      _isImporting = false;
      _statusMessage = 'Đã dừng import';
    });
  }

  String _createDocId(String word, int index) {
    String cleanWord = word
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    
    if (cleanWord.length > 50) {
      cleanWord = cleanWord.substring(0, 50);
    }
    
    return '${cleanWord}_$index';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Vocabulary to Firestore'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _statusMessage,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isImporting) ...[
                      LinearProgressIndicator(
                        value: _progress,
                        minHeight: 10,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(_progress * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Đang xử lý: $_currentWord',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Tổng', _totalWords, Colors.blue),
                        _buildStatItem('Thành công', _successCount, Colors.green),
                        _buildStatItem('Bỏ qua', _skipCount, Colors.orange),
                        _buildStatItem('Lỗi', _errorCount, Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isImporting ? null : _startImport,
                    icon: const Icon(Icons.upload),
                    label: const Text('Bắt đầu Import'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isImporting ? _stopImport : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('Dừng lại'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Logs
            const Text(
              'Logs:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        _logs[index],
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
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

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

