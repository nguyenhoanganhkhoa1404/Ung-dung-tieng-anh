import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_config.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../components/flashcard.dart';
import '../components/progress_bar.dart';
import '../../core/services/tts_service.dart';

/// FlashcardScreen - Màn hình học từ vựng với flashcard riêng biệt
/// Thin progress bar at top, central flashcard, glowing microphone button
class FlashcardScreen extends StatefulWidget {
  final String userId;

  const FlashcardScreen({
    super.key,
    required this.userId,
  });

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final TtsService _tts = TtsService();
  static const List<String> _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
  List<Map<String, dynamic>> _vocabularyList = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _showMeaning = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _loadVocabulary();
  }

  Future<void> _loadVocabulary() async {
    try {
      // Load từ vựng từ tất cả các level A1-C2
      final List<Map<String, dynamic>> allWords = [];
      
      for (final level in _levels) {
        final snapshot = await FirebaseFirestore.instance
            .collection('vocabulary')
            .where('level', isEqualTo: level)
            .get();
        
        allWords.addAll(
          snapshot.docs.map((doc) => {
                'id': doc.id,
                ...doc.data(),
              }),
        );
      }

      // Shuffle và chỉ lấy 10 từ ngẫu nhiên
      allWords.shuffle();
      final selectedWords = allWords.take(10).toList();

      setState(() {
        _vocabularyList = selectedWords;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải từ vựng: $e')),
        );
      }
    }
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'A1':
        return const Color(0xFF4CAF50);
      case 'A2':
        return const Color(0xFF66BB6A);
      case 'B1':
        return const Color(0xFF2196F3);
      case 'B2':
        return const Color(0xFF1976D2);
      case 'C1':
        return const Color(0xFFFF9800);
      case 'C2':
        return const Color(0xFFF57C00);
      default:
        return LingoFlowColors.oceanBlue;
    }
  }

  void _nextCard() {
    if (_currentIndex < _vocabularyList.length - 1) {
      setState(() {
        _currentIndex++;
        _showMeaning = false;
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showMeaning = false;
      });
    }
  }

  void _toggleMeaning() {
    setState(() {
      _showMeaning = !_showMeaning;
    });
  }

  Future<void> _speakWord() async {
    final word = _vocabularyList[_currentIndex]['word']?.toString() ?? '';
    if (word.isNotEmpty) {
      await _tts.speak(word);
    }
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      // TODO: Implement actual recording functionality
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? LingoFlowColors.darkBackground : Colors.grey[50];

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: const Text('Học từ mới'),
          backgroundColor: LingoFlowColors.oceanBlue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_vocabularyList.isEmpty) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: const Text('Học từ mới'),
          backgroundColor: LingoFlowColors.oceanBlue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.style_rounded,
                size: 64,
                color: LingoFlowColors.gray,
              ),
              const SizedBox(height: 16),
              Text(
                'Chưa có từ vựng',
                style: LingoFlowTypography.headlineMedium(context),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Đang tải từ vựng, đợi chút nhé...',
                  textAlign: TextAlign.center,
                  style: LingoFlowTypography.bodyMedium(context),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final currentWord = _vocabularyList[_currentIndex];
    final progress = (_currentIndex + 1) / _vocabularyList.length;
    final currentLevel = currentWord['level']?.toString() ?? 'A1';
    final levelColor = _getLevelColor(currentLevel);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Học từ mới'),
        backgroundColor: LingoFlowColors.oceanBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress bar at top
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Từ ${_currentIndex + 1} / ${_vocabularyList.length}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ProgressBar(
                  progress: progress,
                  height: 5,
                  progressColor: LingoFlowColors.oceanBlue,
                ),
              ],
            ),
          ),

          // Central flashcard
          Expanded(
            child: GestureDetector(
              onTap: _toggleMeaning,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Flashcard với word và level
                      Column(
                        children: [
                          // Level badge
                          Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: levelColor.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Level $currentLevel',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          // Flashcard với word
                          Flashcard(
                            imageUrl: currentWord['imageUrl']?.toString(),
                            word: currentWord['word']?.toString() ?? '',
                            phonetic: currentWord['pronunciation']?.toString(),
                            onSpeaker: _speakWord,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Meaning card (flip khi tap)
                      AnimatedOpacity(
                        opacity: _showMeaning ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark 
                                ? LingoFlowColors.darkCardBackground 
                                : Colors.white,
                            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.3)
                                    : LingoFlowColors.oceanBlue.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Nghĩa',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                currentWord['meaning']?.toString() ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              if (currentWord['example'] != null) ...[
                                const SizedBox(height: 14),
                                Divider(
                                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                                  height: 1,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Ví dụ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  currentWord['example']?.toString() ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Navigation buttons và microphone button
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Previous/Next buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      onPressed: _currentIndex > 0 ? _previousCard : null,
                      color: LingoFlowColors.oceanBlue,
                    ),
                    Text(
                      'Chạm vào thẻ để xem nghĩa',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.grey[500] : Colors.grey[600],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: _currentIndex < _vocabularyList.length - 1 
                          ? _nextCard 
                          : null,
                      color: LingoFlowColors.oceanBlue,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Glowing Ocean Blue microphone button với pulse animation
                Center(
                  child: _buildRecordButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordButton() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: LingoFlowColors.oceanBlue,
        boxShadow: [
          BoxShadow(
            color: LingoFlowColors.oceanBlue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleRecording,
          borderRadius: BorderRadius.circular(40),
          child: Center(
            child: Icon(
              _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
