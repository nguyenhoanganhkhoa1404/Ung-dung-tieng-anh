import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/widgets/custom_button.dart';

class PlacementTestPage extends StatefulWidget {
  const PlacementTestPage({super.key});

  @override
  State<PlacementTestPage> createState() => _PlacementTestPageState();
}

class _PlacementTestPageState extends State<PlacementTestPage> {
  int _currentQuestion = 0;
  int _correctAnswers = 0;
  String? _selectedAnswer;

  final List<TestQuestion> _questions = [
    TestQuestion(
      question: 'What _____ your name?',
      options: ['is', 'are', 'am', 'be'],
      correctAnswer: 'is',
      level: 'A1',
    ),
    TestQuestion(
      question: 'I _____ English every day.',
      options: ['study', 'studies', 'studied', 'studying'],
      correctAnswer: 'study',
      level: 'A1',
    ),
    TestQuestion(
      question: 'She _____ to the park yesterday.',
      options: ['go', 'goes', 'went', 'going'],
      correctAnswer: 'went',
      level: 'A2',
    ),
    TestQuestion(
      question: 'If I _____ rich, I would travel the world.',
      options: ['am', 'was', 'were', 'be'],
      correctAnswer: 'were',
      level: 'B1',
    ),
    TestQuestion(
      question: 'By the time you arrive, I _____ dinner.',
      options: [
        'will finish',
        'will have finished',
        'finish',
        'have finished'
      ],
      correctAnswer: 'will have finished',
      level: 'B2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài Test Đầu Vào'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProgressBar(),
              const SizedBox(height: 32),
              _buildQuestionCard(),
              const Spacer(),
              CustomButton(
                text: _currentQuestion < _questions.length - 1
                    ? 'Tiếp theo'
                    : 'Hoàn thành',
                onPressed: _selectedAnswer != null ? _handleNext : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = (_currentQuestion + 1) / _questions.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Câu hỏi ${_currentQuestion + 1}/${_questions.length}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          minHeight: 8,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
    final question = _questions[_currentQuestion];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getLevelColor(question.level).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Cấp độ: ${question.level}',
                style: TextStyle(
                  color: _getLevelColor(question.level),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              question.question,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            ...question.options.map((option) => _buildOptionButton(option)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    final isSelected = _selectedAnswer == option;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedAnswer = option;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor
                  : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.textPrimary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'A1':
        return AppColors.levelA1;
      case 'A2':
        return AppColors.levelA2;
      case 'B1':
        return AppColors.levelB1;
      case 'B2':
        return AppColors.levelB2;
      case 'C1':
        return AppColors.levelC1;
      case 'C2':
        return AppColors.levelC2;
      default:
        return AppColors.primaryColor;
    }
  }

  void _handleNext() {
    if (_selectedAnswer == _questions[_currentQuestion].correctAnswer) {
      _correctAnswers++;
    }

    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    final accuracy = (_correctAnswers / _questions.length * 100).round();
    String level = 'A1';
    
    if (accuracy >= 80) {
      level = 'B2';
    } else if (accuracy >= 60) {
      level = 'B1';
    } else if (accuracy >= 40) {
      level = 'A2';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Kết quả Test'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 64,
              color: AppColors.goldColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Trình độ của bạn',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              level,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: _getLevelColor(level),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bạn đã trả lời đúng $_correctAnswers/${_questions.length} câu',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(AppRouter.home);
            },
            child: const Text('Bắt đầu học'),
          ),
        ],
      ),
    );
  }
}

class TestQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String level;

  TestQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.level,
  });
}

