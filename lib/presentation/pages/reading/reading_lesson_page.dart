import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class ReadingLessonPage extends StatefulWidget {
  final String level;
  final String title;
  
  const ReadingLessonPage({
    super.key,
    required this.level,
    required this.title,
  });

  @override
  State<ReadingLessonPage> createState() => _ReadingLessonPageState();
}

class _ReadingLessonPageState extends State<ReadingLessonPage> {
  final int _currentQuestionIndex = 0;
  final Map<int, String> _selectedAnswers = {};
  bool _showResults = false;
  int _score = 0;
  
  late ReadingPassage _passage;
  
  @override
  void initState() {
    super.initState();
    _passage = _getPassageForLevel(widget.level);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _showResults ? _buildResultsView() : _buildReadingView(),
    );
  }
  
  Widget _buildReadingView() {
    return Column(
      children: [
        _buildProgressBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReadingPassage(),
                _buildQuestions(),
              ],
            ),
          ),
        ),
        _buildSubmitButton(),
      ],
    );
  }
  
  Widget _buildProgressBar() {
    final answeredCount = _selectedAnswers.length;
    final totalQuestions = _passage.questions.length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: answeredCount / totalQuestions,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.readingColor),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '$answeredCount/$totalQuestions',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReadingPassage() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _passage.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Level: ${widget.level} • ${_passage.wordCount} words',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const Divider(height: 32),
          Text(
            _passage.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuestions() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Câu hỏi',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._passage.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return _buildQuestionCard(index, question);
          }),
        ],
      ),
    );
  }
  
  Widget _buildQuestionCard(int index, ReadingQuestion question) {
    final isAnswered = _selectedAnswers.containsKey(index);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: isAnswered 
                      ? AppColors.readingColor
                      : Colors.grey.shade300,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isAnswered ? Colors.white : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.question,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...question.options.asMap().entries.map((entry) {
              final optionIndex = entry.key;
              final option = entry.value;
              final optionLetter = String.fromCharCode(65 + optionIndex);
              final isSelected = _selectedAnswers[index] == optionLetter;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAnswers[index] = optionLetter;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.readingColor.withOpacity(0.1)
                        : Colors.white,
                    border: Border.all(
                      color: isSelected 
                          ? AppColors.readingColor
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppColors.readingColor
                              : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            optionLetter,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(option),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSubmitButton() {
    final canSubmit = _selectedAnswers.length == _passage.questions.length;
    
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
            onPressed: canSubmit ? _submitAnswers : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.readingColor,
            ),
            child: Text(
              canSubmit 
                  ? 'Nộp bài (${_selectedAnswers.length}/${_passage.questions.length})'
                  : 'Vui lòng trả lời tất cả câu hỏi',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
  
  void _submitAnswers() {
    int correctCount = 0;
    
    for (int i = 0; i < _passage.questions.length; i++) {
      if (_selectedAnswers[i] == _passage.questions[i].correctAnswer) {
        correctCount++;
      }
    }
    
    setState(() {
      _score = correctCount;
      _showResults = true;
    });
  }
  
  Widget _buildResultsView() {
    final percentage = (_score / _passage.questions.length * 100).round();
    final xpEarned = _score * 25;
    
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
    
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 100, color: color),
            const SizedBox(height: 24),
            Text(
              message,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '$_score/${_passage.questions.length}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đúng $percentage%',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.goldColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                '+$xpEarned XP',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.goldColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Về danh sách'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedAnswers.clear();
                        _showResults = false;
                        _score = 0;
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Làm lại'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.readingColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  ReadingPassage _getPassageForLevel(String level) {
    switch (level) {
      case 'A1':
        return ReadingPassage(
          title: 'My Family',
          level: 'A1',
          wordCount: 150,
          content: '''My name is Tom. I am ten years old. I live in a small house with my family. There are four people in my family: my father, my mother, my sister, and me.

My father is a teacher. He teaches English at a school. He is very kind and funny. My mother is a nurse. She works at a hospital. She helps sick people every day.

I have one sister. Her name is Anna. She is eight years old. She likes drawing and singing. We go to the same school. We walk to school together every morning.

On weekends, we usually go to the park. We play games and have picnics. I love my family very much.''',
          questions: [
            ReadingQuestion(
              question: 'How old is Tom?',
              options: ['Eight years old', 'Ten years old', 'Twelve years old', 'Seven years old'],
              correctAnswer: 'B',
            ),
            ReadingQuestion(
              question: 'What is Tom\'s father\'s job?',
              options: ['Doctor', 'Teacher', 'Nurse', 'Engineer'],
              correctAnswer: 'B',
            ),
            ReadingQuestion(
              question: 'How many people are there in Tom\'s family?',
              options: ['Three', 'Four', 'Five', 'Six'],
              correctAnswer: 'B',
            ),
            ReadingQuestion(
              question: 'What does Anna like doing?',
              options: ['Cooking and reading', 'Swimming and running', 'Drawing and singing', 'Dancing and playing'],
              correctAnswer: 'C',
            ),
          ],
        );
      default:
        return ReadingPassage(
          title: 'Sample Passage',
          level: level,
          wordCount: 200,
          content: 'Sample content for level $level',
          questions: [],
        );
    }
  }
}

class ReadingPassage {
  final String title;
  final String level;
  final int wordCount;
  final String content;
  final List<ReadingQuestion> questions;
  
  ReadingPassage({
    required this.title,
    required this.level,
    required this.wordCount,
    required this.content,
    required this.questions,
  });
}

class ReadingQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  
  ReadingQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

