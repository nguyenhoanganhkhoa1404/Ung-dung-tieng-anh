import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class GrammarLessonPage extends StatefulWidget {
  final String topic;
  final String topicTitle;
  
  const GrammarLessonPage({
    super.key,
    required this.topic,
    required this.topicTitle,
  });

  @override
  State<GrammarLessonPage> createState() => _GrammarLessonPageState();
}

class _GrammarLessonPageState extends State<GrammarLessonPage> {
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  bool _showExplanation = false;
  String? _selectedAnswer;
  
  late List<GrammarQuestion> _questions;
  
  @override
  void initState() {
    super.initState();
    _questions = _getQuestionsForTopic(widget.topic);
  }
  
  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicTitle),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_currentQuestionIndex + 1}/${_questions.length}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuestionCard(question),
                    const SizedBox(height: 24),
                    _buildAnswerOptions(question),
                    if (_showExplanation) ...[
                      const SizedBox(height: 24),
                      _buildExplanation(question),
                    ],
                  ],
                ),
              ),
            ),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: (_currentQuestionIndex + 1) / _questions.length,
      minHeight: 6,
      backgroundColor: Colors.grey.shade300,
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.grammarColor),
    );
  }
  
  Widget _buildQuestionCard(GrammarQuestion question) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.grammarColor.withOpacity(0.2),
                  child: Text(
                    '${_currentQuestionIndex + 1}',
                    style: TextStyle(
                      color: AppColors.grammarColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Chọn đáp án đúng',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              question.question,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAnswerOptions(GrammarQuestion question) {
    return Column(
      children: question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final optionLetter = String.fromCharCode(65 + index); // A, B, C, D
        
        final isSelected = _selectedAnswer == optionLetter;
        final isCorrect = optionLetter == question.correctAnswer;
        
        Color? backgroundColor;
        Color? borderColor;
        IconData? icon;
        
        if (_showExplanation) {
          if (isCorrect) {
            backgroundColor = AppColors.successColor.withOpacity(0.1);
            borderColor = AppColors.successColor;
            icon = Icons.check_circle;
          } else if (isSelected && !isCorrect) {
            backgroundColor = AppColors.errorColor.withOpacity(0.1);
            borderColor = AppColors.errorColor;
            icon = Icons.cancel;
          }
        } else if (isSelected) {
          backgroundColor = AppColors.grammarColor.withOpacity(0.1);
          borderColor = AppColors.grammarColor;
        }
        
        return GestureDetector(
          onTap: _showExplanation ? null : () {
            setState(() {
              _selectedAnswer = optionLetter;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              border: Border.all(
                color: borderColor ?? Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: borderColor?.withOpacity(0.2) ?? Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      optionLetter,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: borderColor ?? Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                if (icon != null)
                  Icon(icon, color: borderColor),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildExplanation(GrammarQuestion question) {
    final isCorrect = _selectedAnswer == question.correctAnswer;
    
    return Card(
      color: isCorrect 
          ? AppColors.successColor.withOpacity(0.1) 
          : AppColors.errorColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.info_outline,
                  color: isCorrect ? AppColors.successColor : AppColors.errorColor,
                ),
                const SizedBox(width: 8),
                Text(
                  isCorrect ? 'Chính xác!' : 'Giải thích',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? AppColors.successColor : AppColors.errorColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              question.explanation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedAnswer == null ? null : () {
              if (_showExplanation) {
                _nextQuestion();
              } else {
                _checkAnswer();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.grammarColor,
            ),
            child: Text(
              _showExplanation 
                  ? (_currentQuestionIndex < _questions.length - 1 
                      ? 'Câu tiếp theo' 
                      : 'Xem kết quả')
                  : 'Kiểm tra',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
  
  void _checkAnswer() {
    if (_selectedAnswer == _questions[_currentQuestionIndex].correctAnswer) {
      _correctAnswers++;
    }
    
    setState(() {
      _showExplanation = true;
    });
  }
  
  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showExplanation = false;
      });
    } else {
      _showResultDialog();
    }
  }
  
  void _showResultDialog() {
    final percentage = (_correctAnswers / _questions.length * 100).round();
    final xpEarned = _correctAnswers * 20;
    
    String message;
    IconData icon;
    Color color;
    
    if (percentage >= 80) {
      message = 'Xuất sắc!';
      icon = Icons.emoji_events;
      color = AppColors.goldColor;
    } else if (percentage >= 60) {
      message = 'Tốt lắm!';
      icon = Icons.thumb_up;
      color = AppColors.successColor;
    } else {
      message = 'Cố gắng thêm nhé!';
      icon = Icons.favorite;
      color = AppColors.primaryColor;
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_correctAnswers/${_questions.length}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đúng $percentage%',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.goldColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+$xpEarned XP',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.goldColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Back to grammar list
            },
            child: const Text('Về danh sách'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              setState(() {
                _currentQuestionIndex = 0;
                _correctAnswers = 0;
                _selectedAnswer = null;
                _showExplanation = false;
                _questions = _getQuestionsForTopic(widget.topic);
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Làm lại'),
          ),
        ],
      ),
    );
  }
  
  List<GrammarQuestion> _getQuestionsForTopic(String topic) {
    // Real grammar questions for each topic
    switch (topic) {
      case 'present_simple':
        return _presentSimpleQuestions;
      case 'present_continuous':
        return _presentContinuousQuestions;
      case 'past_simple':
        return _pastSimpleQuestions;
      case 'future_simple':
        return _futureSimpleQuestions;
      case 'present_perfect':
        return _presentPerfectQuestions;
      default:
        return _presentSimpleQuestions;
    }
  }
  
  // Present Simple Questions
  final List<GrammarQuestion> _presentSimpleQuestions = [
    GrammarQuestion(
      question: 'She ___ to school every day.',
      options: ['go', 'goes', 'going', 'went'],
      correctAnswer: 'B',
      explanation: 'Với chủ ngữ she/he/it, động từ cần thêm "s" hoặc "es" trong thì hiện tại đơn.',
    ),
    GrammarQuestion(
      question: 'They ___ coffee in the morning.',
      options: ['drinks', 'drink', 'drinking', 'drank'],
      correctAnswer: 'B',
      explanation: 'Với chủ ngữ số nhiều (they), động từ giữ nguyên dạng gốc trong thì hiện tại đơn.',
    ),
    GrammarQuestion(
      question: 'I ___ English every day.',
      options: ['study', 'studies', 'studied', 'studying'],
      correctAnswer: 'A',
      explanation: 'Với chủ ngữ I/you/we/they, động từ giữ nguyên dạng gốc.',
    ),
    GrammarQuestion(
      question: 'He ___ work at 8 AM.',
      options: ['start', 'starts', 'starting', 'started'],
      correctAnswer: 'B',
      explanation: 'Với he/she/it, động từ thêm "s". Start → starts.',
    ),
    GrammarQuestion(
      question: 'We ___ in Ho Chi Minh City.',
      options: ['lives', 'live', 'living', 'lived'],
      correctAnswer: 'B',
      explanation: 'Với we/you/they, động từ giữ nguyên.',
    ),
  ];
  
  // Present Continuous Questions
  final List<GrammarQuestion> _presentContinuousQuestions = [
    GrammarQuestion(
      question: 'She ___ a book right now.',
      options: ['read', 'reads', 'is reading', 'reading'],
      correctAnswer: 'C',
      explanation: 'Thì hiện tại tiếp diễn: am/is/are + V-ing. She → is reading.',
    ),
    GrammarQuestion(
      question: 'They ___ football at the moment.',
      options: ['play', 'plays', 'are playing', 'playing'],
      correctAnswer: 'C',
      explanation: 'They → are playing (đang chơi).',
    ),
    GrammarQuestion(
      question: 'I ___ to music now.',
      options: ['listen', 'listening', 'am listening', 'listens'],
      correctAnswer: 'C',
      explanation: 'I → am listening (đang nghe).',
    ),
    GrammarQuestion(
      question: 'He ___ his homework now.',
      options: ['do', 'does', 'is doing', 'doing'],
      correctAnswer: 'C',
      explanation: 'He → is doing (đang làm).',
    ),
    GrammarQuestion(
      question: 'We ___ dinner at the moment.',
      options: ['cook', 'cooks', 'are cooking', 'cooking'],
      correctAnswer: 'C',
      explanation: 'We → are cooking (đang nấu).',
    ),
  ];
  
  // Past Simple Questions
  final List<GrammarQuestion> _pastSimpleQuestions = [
    GrammarQuestion(
      question: 'I ___ to the cinema yesterday.',
      options: ['go', 'goes', 'went', 'going'],
      correctAnswer: 'C',
      explanation: 'Thì quá khứ đơn, động từ go → went.',
    ),
    GrammarQuestion(
      question: 'She ___ a new car last month.',
      options: ['buy', 'buys', 'bought', 'buying'],
      correctAnswer: 'C',
      explanation: 'Buy → bought (động từ bất quy tắc).',
    ),
    GrammarQuestion(
      question: 'They ___ in Hanoi two years ago.',
      options: ['live', 'lives', 'lived', 'living'],
      correctAnswer: 'C',
      explanation: 'Live → lived (động từ có quy tắc, thêm -ed).',
    ),
    GrammarQuestion(
      question: 'He ___ English when he was young.',
      options: ['learn', 'learns', 'learned', 'learning'],
      correctAnswer: 'C',
      explanation: 'Learn → learned (thêm -ed).',
    ),
    GrammarQuestion(
      question: 'We ___ breakfast at 7 AM.',
      options: ['have', 'has', 'had', 'having'],
      correctAnswer: 'C',
      explanation: 'Have → had (động từ bất quy tắc).',
    ),
  ];
  
  // Future Simple Questions
  final List<GrammarQuestion> _futureSimpleQuestions = [
    GrammarQuestion(
      question: 'I ___ go to school tomorrow.',
      options: ['will', 'would', 'am', 'going'],
      correctAnswer: 'A',
      explanation: 'Thì tương lai đơn: will + V (nguyên thể).',
    ),
    GrammarQuestion(
      question: 'She ___ visit her grandparents next week.',
      options: ['will', 'would', 'is', 'visiting'],
      correctAnswer: 'A',
      explanation: 'Will + visit (sẽ đến thăm).',
    ),
    GrammarQuestion(
      question: 'They ___ come to the party tonight.',
      options: ['will', 'would', 'are', 'coming'],
      correctAnswer: 'A',
      explanation: 'Will + come (sẽ đến).',
    ),
    GrammarQuestion(
      question: 'He ___ finish his work soon.',
      options: ['will', 'would', 'is', 'finishing'],
      correctAnswer: 'A',
      explanation: 'Will + finish (sẽ hoàn thành).',
    ),
    GrammarQuestion(
      question: 'We ___ travel to Japan next year.',
      options: ['will', 'would', 'are', 'traveling'],
      correctAnswer: 'A',
      explanation: 'Will + travel (sẽ đi du lịch).',
    ),
  ];
  
  // Present Perfect Questions
  final List<GrammarQuestion> _presentPerfectQuestions = [
    GrammarQuestion(
      question: 'I ___ already ___ my homework.',
      options: ['have / do', 'have / done', 'has / done', 'had / done'],
      correctAnswer: 'B',
      explanation: 'Thì hiện tại hoàn thành: have/has + V3/V-ed. I → have done.',
    ),
    GrammarQuestion(
      question: 'She ___ never ___ sushi.',
      options: ['have / eat', 'has / eaten', 'have / eaten', 'had / eaten'],
      correctAnswer: 'B',
      explanation: 'She → has eaten (chưa bao giờ ăn).',
    ),
    GrammarQuestion(
      question: 'They ___ just ___ from school.',
      options: ['have / return', 'have / returned', 'has / returned', 'had / returned'],
      correctAnswer: 'B',
      explanation: 'They → have returned (vừa trở về).',
    ),
    GrammarQuestion(
      question: 'He ___ lived here ___ 2010.',
      options: ['has / for', 'have / since', 'has / since', 'had / since'],
      correctAnswer: 'C',
      explanation: 'Since + mốc thời gian. He → has lived since 2010.',
    ),
    GrammarQuestion(
      question: 'We ___ known each other ___ 5 years.',
      options: ['have / for', 'have / since', 'has / for', 'had / for'],
      correctAnswer: 'A',
      explanation: 'For + khoảng thời gian. We → have known for 5 years.',
    ),
  ];
}

class GrammarQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  
  GrammarQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}

