import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/services/tts_service.dart';
import '../../../data/repositories/analytics_repository_impl.dart';
import '../../../domain/entities/learning_session_entity.dart';

/// Trang học từ vựng với flashcards
class VocabularyLearningPage extends StatefulWidget {
  final String level;
  final String levelTitle;
  final List<Map<String, dynamic>> vocabularyList;
  final String userId;

  const VocabularyLearningPage({
    super.key,
    required this.level,
    required this.levelTitle,
    required this.vocabularyList,
    required this.userId,
  });

  @override
  State<VocabularyLearningPage> createState() => _VocabularyLearningPageState();
}

class _VocabularyLearningPageState extends State<VocabularyLearningPage> {
  int _currentIndex = 0;
  int _correctCount = 0;
  int _wrongCount = 0;
  late List<Map<String, dynamic>> _shuffledList;
  bool _isCompleted = false;
  int? _selectedAnswerIndex;
  bool _hasAnswered = false;
  late List<String> _currentOptions;
  late int _correctAnswerIndex;
  late final AnalyticsRepositoryImpl _repo;
  String? _sessionId;
  bool _persisted = false;
  final TtsService _tts = TtsService();

  @override
  void initState() {
    super.initState();
    // Shuffle và lấy 20 từ ngẫu nhiên
    _shuffledList = List.from(widget.vocabularyList)..shuffle();
    _shuffledList = _shuffledList.take(20).toList();
    _generateOptions();

    _repo = AnalyticsRepositoryImpl();
    Future.microtask(_startSessionIfPossible);
  }

  Future<void> _startSessionIfPossible() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? widget.userId;
    if (uid.isEmpty) return;

    try {
      _sessionId = await _repo.startLearningSession(
        userId: uid,
        skill: SkillType.vocabulary,
        lessonId: 'vocab:${widget.level}',
      );
    } catch (_) {
      // Ignore tracking failures (should not block learning)
    }
  }

  void _generateOptions() {
    final currentWord = _shuffledList[_currentIndex];
    final correctMeaning = currentWord['meaning'].toString();
    
    // Lấy 3 đáp án sai khác
    final otherWords = List.from(widget.vocabularyList)
        .where((w) => w['meaning'] != correctMeaning)
        .toList()
      ..shuffle();
    
    final wrongOptions = otherWords.take(3).map((w) => w['meaning'].toString()).toList();
    
    // Tạo danh sách 4 đáp án
    _currentOptions = [correctMeaning, ...wrongOptions];
    _currentOptions.shuffle();
    
    // Lưu vị trí đáp án đúng
    _correctAnswerIndex = _currentOptions.indexOf(correctMeaning);
  }

  Color _getLevelColor() {
    switch (widget.level) {
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
        return Colors.blue;
    }
  }

  void _selectAnswer(int index) {
    if (_hasAnswered) return;
    
    setState(() {
      _selectedAnswerIndex = index;
      _hasAnswered = true;
      
      if (index == _correctAnswerIndex) {
        _correctCount++;
      } else {
        _wrongCount++;
      }
    });
    // Không auto-next nữa: người học tự bấm "Next Question"
  }

  void _nextWord() {
    if (_currentIndex < _shuffledList.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null;
        _hasAnswered = false;
      });
      _generateOptions();
    } else {
      setState(() {
        _isCompleted = true;
      });
      _persistResultIfNeeded();
    }
  }

  Future<void> _persistResultIfNeeded() async {
    if (_persisted) return;
    _persisted = true;

    final uid = FirebaseAuth.instance.currentUser?.uid ?? widget.userId;
    if (uid.isEmpty) return;

    try {
      await _repo.saveExerciseResult(
        userId: uid,
        skill: SkillType.vocabulary,
        correctAnswers: _correctCount,
        totalQuestions: _shuffledList.length,
        completed: true,
        lessonId: 'vocab:${widget.level}',
        sessionId: _sessionId,
      );

      if (_sessionId != null) {
        await _repo.completeLearningSession(_sessionId!);
      }
    } catch (_) {
      // Ignore tracking failures (should not block learning)
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = _getLevelColor();
    final currentWord =
        _isCompleted ? null : _shuffledList[_currentIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[50];

    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Learning ${widget.level}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : levelColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Progress
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentIndex + 1}/${_shuffledList.length}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isCompleted ? _buildResultScreen(levelColor) : _buildLearningScreen(currentWord!, levelColor),
    );
  }

  Widget _buildLearningScreen(Map<String, dynamic> word, Color levelColor) {
    return Column(
      children: [
        // Stats Bar
        Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: _buildStatChip(
                  'Đúng',
                  _correctCount.toString(),
                  Colors.green,
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatChip(
                  'Sai',
                  _wrongCount.toString(),
                  Colors.red,
                  Icons.cancel,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatChip(
                  'Còn lại',
                  (_shuffledList.length - _currentIndex - 1).toString(),
                  Colors.grey,
                  Icons.hourglass_empty,
                ),
              ),
            ],
          ),
        ),

        // Progress Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: GFProgressBar(
            percentage: (_currentIndex + 1) / _shuffledList.length,
            lineHeight: 8,
            backgroundColor: Colors.grey[200]!,
            progressBarColor: levelColor,
            circleWidth: 0,
          ),
        ),

        // Quiz Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Question Card
                _buildQuizQuestionCard(word, levelColor),
                const SizedBox(height: 20),

                // Multiple Choice Options
                ...List.generate(
                  _currentOptions.length,
                  (index) => _buildOptionCard(
                    index,
                    _currentOptions[index],
                    levelColor,
                  ),
                ),

                // Explanation Card (show after answer)
                if (_hasAnswered) ...[
                  const SizedBox(height: 20),
                  _buildExplanationCard(word, levelColor),
                  const SizedBox(height: 16),
                  
                  // Next Button
                  GFButton(
                    onPressed: _nextWord,
                    text: _currentIndex < _shuffledList.length - 1
                        ? 'Câu tiếp theo'
                        : 'Xem kết quả',
                    color: levelColor,
                    size: GFSize.LARGE,
                    fullWidthButton: true,
                    shape: GFButtonShape.pills,
                    icon: Icon(
                      _currentIndex < _shuffledList.length - 1
                          ? Icons.arrow_forward
                          : Icons.check_circle,
                      color: Colors.white,
                    ),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizQuestionCard(Map<String, dynamic> word, Color levelColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : levelColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.help_outline, size: 48, color: levelColor),
          const SizedBox(height: 12),
          Text(
            'What does this word mean?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: subTextColor,
            ),
          ),
          const SizedBox(height: 16),
          
          // Word with Speaker Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                word['word'].toString(),
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 12),
              // Speaker Button
              GestureDetector(
                onTap: () {
                  _tts.speak(word['word'].toString());
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: levelColor.withOpacity(isDark ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.volume_up_rounded,
                    color: levelColor,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          if (word['pronunciation'] != null &&
              word['pronunciation'].toString().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              word['pronunciation'].toString(),
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: subTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: levelColor.withOpacity(isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              word['partOfSpeech'].toString(),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: levelColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(int index, String option, Color levelColor) {
    final isSelected = _selectedAnswerIndex == index;
    final isCorrect = index == _correctAnswerIndex;
    final showResult = _hasAnswered;

    Color getCardColor() {
      if (!showResult) {
        return isSelected ? levelColor.withOpacity(0.1) : Colors.white;
      }
      if (isCorrect) {
        return Colors.green.withOpacity(0.1);
      }
      if (isSelected && !isCorrect) {
        return Colors.red.withOpacity(0.1);
      }
      return Colors.white;
    }

    Color getBorderColor() {
      if (!showResult) {
        return isSelected ? levelColor : Colors.grey[300]!;
      }
      if (isCorrect) {
        return Colors.green;
      }
      if (isSelected && !isCorrect) {
        return Colors.red;
      }
      return Colors.grey[300]!;
    }

    IconData? getIcon() {
      if (!showResult) return null;
      if (isCorrect) return Icons.check_circle;
      if (isSelected && !isCorrect) return Icons.cancel;
      return null;
    }

    return GestureDetector(
      onTap: () => _selectAnswer(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: getCardColor(),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: getBorderColor(), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: showResult && isCorrect
                    ? Colors.green
                    : showResult && isSelected && !isCorrect
                        ? Colors.red
                        : isSelected
                            ? levelColor
                            : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: showResult && getIcon() != null
                  ? Icon(getIcon(), color: Colors.white, size: 20)
                  : Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected || (showResult && isCorrect)
                            ? Colors.white
                            : Colors.grey[700],
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight:
                      showResult && isCorrect ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard(Map<String, dynamic> word, Color levelColor) {
    final isCorrect = _selectedAnswerIndex == _correctAnswerIndex;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.withOpacity(0.08)
            : Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCorrect
              ? Colors.green.withOpacity(0.25)
              : Colors.orange.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.lightbulb,
                color: isCorrect ? Colors.green : Colors.orange[700],
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Đúng rồi! 👍' : 'Xem lại nhé',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isCorrect ? Colors.green : Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Word & Meaning
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: levelColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word['word'].toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (word['pronunciation'] != null &&
                          word['pronunciation'].toString().isNotEmpty)
                        Text(
                          word['pronunciation'].toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    word['meaning'].toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: levelColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Example
          if (word['example'] != null &&
              word['example'].toString().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.format_quote, size: 16, color: levelColor),
                      const SizedBox(width: 6),
                      Text(
                        'Ví dụ',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    word['example'].toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  if (word['exampleTranslation'] != null &&
                      word['exampleTranslation'].toString().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '→ ${word['exampleTranslation']}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Synonyms
          if (word['synonyms'] != null &&
              (word['synonyms'] as List).isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.swap_horiz, size: 16, color: Colors.blue),
                const SizedBox(width: 6),
                Text(
                  'Synonyms:',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: (word['synonyms'] as List)
                        .map((syn) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.blue.withOpacity(0.3)),
                              ),
                              child: Text(
                                syn.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.blue,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ],

          // Antonyms
          if (word['antonyms'] != null &&
              (word['antonyms'] as List).isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.compare_arrows, size: 16, color: Colors.red),
                const SizedBox(width: 6),
                Text(
                  'Antonyms:',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: (word['antonyms'] as List)
                        .map((ant) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.red.withOpacity(0.3)),
                              ),
                              child: Text(
                                ant.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.red,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatChip(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen(Color levelColor) {
    final total = _correctCount + _wrongCount;
    final accuracy = total > 0 ? (_correctCount / total * 100).toInt() : 0;
    final isPassed = accuracy >= 60;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            isPassed ? Icons.emoji_events : Icons.replay,
            size: 100,
            color: isPassed ? Colors.amber : Colors.grey,
          ),
          const SizedBox(height: 24),
            Text(
            isPassed ? 'Làm tốt lắm! 🎉' : 'Tiếp tục cố gắng nhé!',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bạn đã hoàn thành level ${widget.level}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),

          // Stats
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '$accuracy%',
                  style: GoogleFonts.poppins(
                    fontSize: 52,
                    fontWeight: FontWeight.w600,
                    color: levelColor,
                  ),
                ),
                Text(
                  'Độ chính xác',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _buildResultStat(
                        'Đúng',
                        _correctCount.toString(),
                        Colors.green,
                        Icons.check_circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildResultStat(
                        'Sai',
                        _wrongCount.toString(),
                        Colors.red,
                        Icons.cancel,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Actions
          GFButton(
            onPressed: () {
              setState(() {
                _currentIndex = 0;
                _correctCount = 0;
                _wrongCount = 0;
                _selectedAnswerIndex = null;
                _hasAnswered = false;
                _isCompleted = false;
                _shuffledList = List.from(widget.vocabularyList)..shuffle();
                _shuffledList = _shuffledList.take(20).toList();
              });
              _generateOptions();
            },
            text: 'Làm lại',
            color: levelColor,
            size: GFSize.LARGE,
            fullWidthButton: true,
            shape: GFButtonShape.pills,
            icon: const Icon(Icons.replay, color: Colors.white),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GFButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: 'Back to List',
            color: Colors.grey,
            size: GFSize.LARGE,
            fullWidthButton: true,
            shape: GFButtonShape.pills,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStat(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

