import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/repositories/analytics_repository_impl.dart';
import '../../../domain/entities/learning_session_entity.dart';

/// Trang chi tiết bài học
class LessonDetailPage extends StatefulWidget {
  final String skillName;
  final String lessonTitle;
  final String lessonSubtitle;
  final IconData lessonIcon;
  final Color lessonColor;
  final String userId;

  const LessonDetailPage({
    super.key,
    required this.skillName,
    required this.lessonTitle,
    required this.lessonSubtitle,
    required this.lessonIcon,
    required this.lessonColor,
    required this.userId,
  });

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  int _currentExerciseIndex = 0;
  int _score = 0;
  bool _showResult = false;
  late final List<_LessonExercise> _exercises;
  int? _selectedOptionIndex;
  bool _hasAnswered = false;
  late final AnalyticsRepositoryImpl _repo;
  String? _sessionId;
  bool _persisted = false;

  @override
  void initState() {
    super.initState();
    _exercises = _buildExercisesForLesson(
      skillName: widget.skillName,
      lessonTitle: widget.lessonTitle,
    );

    _repo = AnalyticsRepositoryImpl();
    Future.microtask(_startSessionIfPossible);
  }

  SkillType _mapSkill(String skillName) {
    final s = skillName.toLowerCase();
    if (s.contains('vocab')) return SkillType.vocabulary;
    if (s.contains('grammar')) return SkillType.grammar;
    if (s.contains('listen')) return SkillType.listening;
    if (s.contains('speak')) return SkillType.speaking;
    if (s.contains('read')) return SkillType.reading;
    if (s.contains('writ')) return SkillType.writing;
    return SkillType.vocabulary;
  }

  Future<void> _startSessionIfPossible() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? widget.userId;
    if (uid.isEmpty) return;

    try {
      _sessionId = await _repo.startLearningSession(
        userId: uid,
        skill: _mapSkill(widget.skillName),
        lessonId: '${widget.skillName}:${widget.lessonTitle}',
      );
    } catch (_) {
      // Ignore tracking failures (should not block learning)
    }
  }

  void _goNext() {
    if (_currentExerciseIndex < _exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _selectedOptionIndex = null;
        _hasAnswered = false;
      });
    } else {
      setState(() {
        _showResult = true;
      });
      _persistResultIfNeeded();
    }
  }

  void _skip() {
    if (_currentExerciseIndex < _exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _selectedOptionIndex = null;
        _hasAnswered = false;
      });
    }
  }

  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[50];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          widget.lessonTitle,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : widget.lessonColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Score badge
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '$_score pts',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lesson Header
            _buildLessonHeader(),
            const SizedBox(height: 24),

            // Progress Bar
            _buildProgressBar(),
            const SizedBox(height: 24),

            // Exercise Content
            if (!_showResult) ...[
              _buildExerciseContent(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ] else ...[
              _buildResultScreen(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLessonHeader() {
    return GFCard(
      boxFit: BoxFit.cover,
      color: widget.lessonColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.lessonIcon,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.skillName,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.lessonTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.lessonSubtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final total = _exercises.isEmpty ? 1 : _exercises.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Exercise ${_currentExerciseIndex + 1}/$total',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              '${((_currentExerciseIndex + 1) / total * 100).toInt()}%',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: widget.lessonColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GFProgressBar(
          percentage: (_currentExerciseIndex + 1) / total,
          lineHeight: 10,
          backgroundColor: Colors.grey[200]!,
          progressBarColor: widget.lessonColor,
          circleWidth: 0,
        ),
      ],
    );
  }

  Widget _buildExerciseContent() {
    final exercise =
        _exercises.isEmpty ? _LessonExercise.placeholder() : _exercises[_currentExerciseIndex];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.lessonColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${_currentExerciseIndex + 1}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.lessonColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Choose the correct answer:',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            exercise.question,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(
            exercise.options.length,
            (i) => _buildAnswerOption(
              label: String.fromCharCode(65 + i),
              text: exercise.options[i],
              isCorrect: i == exercise.correctIndex,
              optionIndex: i,
              explanation: exercise.explanation,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOption({
    required String label,
    required String text,
    required bool isCorrect,
    required int optionIndex,
    required String explanation,
  }) {
    final bool isSelected = _selectedOptionIndex == optionIndex;

    Color borderColor() {
      if (!_hasAnswered) return Colors.grey[300]!;
      if (!isSelected) return Colors.grey[200]!;
      return isCorrect ? Colors.green : Colors.red;
    }

    Color backgroundColor() {
      if (!_hasAnswered) return Colors.grey[50]!;
      if (!isSelected) return Colors.grey[50]!;
      return isCorrect ? Colors.green.withOpacity(0.08) : Colors.red.withOpacity(0.08);
    }

    return GestureDetector(
      onTap: () {
        if (_hasAnswered) return;

        setState(() {
          _selectedOptionIndex = optionIndex;
          _hasAnswered = true;
          if (isCorrect) _score += 20;
        });

        GFToast.showToast(
          isCorrect ? 'Correct! +20 points' : 'Wrong. $explanation',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: isCorrect ? Colors.green : Colors.red,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor()),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.lessonColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.lessonColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
            if (_hasAnswered && isSelected)
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GFButton(
            onPressed: () {
              _skip();
            },
            text: 'Skip',
            color: Colors.grey,
            size: GFSize.LARGE,
            shape: GFButtonShape.pills,
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GFButton(
            onPressed: () {
              if (!_hasAnswered) {
                GFToast.showToast(
                  'Select an answer first!',
                  context,
                  toastPosition: GFToastPosition.BOTTOM,
                );
                return;
              }
              _goNext();
            },
            text: 'Next',
            color: widget.lessonColor,
            size: GFSize.LARGE,
            shape: GFButtonShape.pills,
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    final percentage = (_score / 100 * 100).toInt();
    final isPassed = percentage >= 60;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.lessonColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            isPassed ? Icons.check_circle : Icons.cancel,
            size: 80,
            color: isPassed ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            isPassed ? 'Congratulations!' : 'Keep Trying!',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your Score',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$_score / 100',
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: widget.lessonColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$percentage%',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: GFButton(
                  onPressed: () {
                    setState(() {
                      _currentExerciseIndex = 0;
                      _score = 0;
                      _showResult = false;
                      _selectedOptionIndex = null;
                      _hasAnswered = false;
                    });
                  },
                  text: 'Retry',
                  color: Colors.grey,
                  size: GFSize.LARGE,
                  shape: GFButtonShape.pills,
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GFButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Done',
                  color: widget.lessonColor,
                  size: GFSize.LARGE,
                  shape: GFButtonShape.pills,
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _persistResultIfNeeded() async {
    if (_persisted) return;
    _persisted = true;

    final uid = FirebaseAuth.instance.currentUser?.uid ?? widget.userId;
    if (uid.isEmpty) return;

    final totalQuestions = _exercises.isEmpty ? 0 : _exercises.length;
    final correctAnswers = (_score ~/ 20).clamp(0, totalQuestions);

    try {
      await _repo.saveExerciseResult(
        userId: uid,
        skill: _mapSkill(widget.skillName),
        correctAnswers: correctAnswers,
        totalQuestions: totalQuestions,
        completed: true,
        lessonId: '${widget.skillName}:${widget.lessonTitle}',
        sessionId: _sessionId,
      );

      if (_sessionId != null) {
        await _repo.completeLearningSession(_sessionId!);
      }
    } catch (_) {
      // Ignore tracking failures (should not block learning)
    }
  }
}

class _LessonExercise {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const _LessonExercise({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  static _LessonExercise placeholder() => const _LessonExercise(
        question: 'Select the correct answer.',
        options: ['Option A', 'Option B', 'Option C', 'Option D'],
        correctIndex: 0,
        explanation: 'Placeholder.',
      );
}

List<_LessonExercise> _buildExercisesForLesson({
  required String skillName,
  required String lessonTitle,
}) {
  // Grammar question bank (no more “Hello”)
  if (skillName.toLowerCase() == 'grammar') {
    switch (lessonTitle) {
      case 'Present Tenses':
        return const [
          _LessonExercise(
            question: 'She ____ to school every day.',
            options: ['go', 'goes', 'went', 'going'],
            correctIndex: 1,
            explanation: 'Present simple: he/she/it + V-s. → goes',
          ),
          _LessonExercise(
            question: 'Look! It ____ right now.',
            options: ['rains', 'is raining', 'rained', 'rain'],
            correctIndex: 1,
            explanation: 'Present continuous: am/is/are + V-ing.',
          ),
          _LessonExercise(
            question: 'I ____ this movie three times.',
            options: ['watch', 'watched', 'have watched', 'am watching'],
            correctIndex: 2,
            explanation: 'Present perfect: have/has + V3.',
          ),
          _LessonExercise(
            question: 'By 8 PM, I ____ my homework.',
            options: ['finish', 'finished', 'will have finished', 'am finishing'],
            correctIndex: 2,
            explanation: 'Future perfect: will have + V3 (completion before a time).',
          ),
          _LessonExercise(
            question: 'He usually ____ coffee in the morning.',
            options: ['drink', 'drinks', 'drank', 'drinking'],
            correctIndex: 1,
            explanation: 'Habit in present simple: he/she/it + V-s.',
          ),
        ];
      case 'Past Tenses':
        return const [
          _LessonExercise(
            question: 'Yesterday, I ____ to the market.',
            options: ['go', 'went', 'gone', 'going'],
            correctIndex: 1,
            explanation: 'Past simple: V2 for finished actions in the past.',
          ),
          _LessonExercise(
            question: 'At 7 PM, she ____ dinner.',
            options: ['cooked', 'was cooking', 'is cooking', 'cooks'],
            correctIndex: 1,
            explanation: 'Past continuous: was/were + V-ing (action in progress).',
          ),
          _LessonExercise(
            question: 'They ____ already left when we arrived.',
            options: ['have', 'had', 'had', 'were'],
            correctIndex: 2,
            explanation: 'Past perfect: had + V3 (earlier past action).',
          ),
          _LessonExercise(
            question: 'I ____ him before, so I recognized him.',
            options: ['see', 'saw', 'had seen', 'have seen'],
            correctIndex: 2,
            explanation: 'Past perfect for experience before another past event.',
          ),
          _LessonExercise(
            question: 'While I ____ , the phone rang.',
            options: ['sleep', 'slept', 'was sleeping', 'have slept'],
            correctIndex: 2,
            explanation: 'Past continuous for background action interrupted by past simple.',
          ),
        ];
      case 'Modal Verbs':
        return const [
          _LessonExercise(
            question: 'You ____ wear a seatbelt. It’s the law.',
            options: ['can', 'must', 'might', 'could'],
            correctIndex: 1,
            explanation: 'Must = obligation/strong necessity.',
          ),
          _LessonExercise(
            question: '____ you help me, please?',
            options: ['Must', 'Could', 'Should', 'Would'],
            correctIndex: 1,
            explanation: 'Could = polite request.',
          ),
          _LessonExercise(
            question: 'You ____ see a doctor if you feel worse.',
            options: ['should', 'can', 'may', 'mustn’t'],
            correctIndex: 0,
            explanation: 'Should = advice.',
          ),
          _LessonExercise(
            question: 'It ____ rain later, so take an umbrella.',
            options: ['must', 'might', 'should', 'can’t'],
            correctIndex: 1,
            explanation: 'Might = possibility.',
          ),
          _LessonExercise(
            question: 'You ____ smoke here. It’s forbidden.',
            options: ['must', 'mustn’t', 'could', 'may'],
            correctIndex: 1,
            explanation: 'Mustn’t = prohibition.',
          ),
        ];
      case 'Conditionals':
        return const [
          _LessonExercise(
            question: 'If it rains, we ____ at home.',
            options: ['stay', 'stayed', 'will stay', 'would stay'],
            correctIndex: 2,
            explanation: 'First conditional: If + present, will + V.',
          ),
          _LessonExercise(
            question: 'If I ____ rich, I would travel the world.',
            options: ['am', 'was', 'were', 'will be'],
            correctIndex: 2,
            explanation: 'Second conditional: If + past, would + V. Use “were” for all subjects.',
          ),
          _LessonExercise(
            question: 'If she had studied, she ____ the exam.',
            options: ['passes', 'passed', 'would pass', 'would have passed'],
            correctIndex: 3,
            explanation: 'Third conditional: If + had V3, would have + V3.',
          ),
          _LessonExercise(
            question: 'If you heat ice, it ____.',
            options: ['melts', 'melt', 'will melt', 'would melt'],
            correctIndex: 0,
            explanation: 'Zero conditional: facts/science → present simple in both clauses.',
          ),
          _LessonExercise(
            question: 'If I were you, I ____ that.',
            options: ['don’t do', 'won’t do', 'wouldn’t do', 'didn’t do'],
            correctIndex: 2,
            explanation: 'Second conditional advice: If I were you, I would…',
          ),
        ];
      case 'Passive Voice':
        return const [
          _LessonExercise(
            question: 'Active: “They build houses.” → Passive: Houses ____ built.',
            options: ['is', 'are', 'was', 'were'],
            correctIndex: 1,
            explanation: 'Present simple passive: am/is/are + V3. Plural “houses” → are.',
          ),
          _LessonExercise(
            question: 'Active: “She wrote a letter.” → Passive: A letter ____ written.',
            options: ['is', 'was', 'were', 'has'],
            correctIndex: 1,
            explanation: 'Past simple passive: was/were + V3. Singular “a letter” → was.',
          ),
          _LessonExercise(
            question: 'Active: “They will finish the work.” → Passive: The work ____ finished.',
            options: ['will be', 'is', 'was', 'has been'],
            correctIndex: 0,
            explanation: 'Future passive: will be + V3.',
          ),
          _LessonExercise(
            question: 'Active: “People speak English worldwide.” → Passive: English ____ worldwide.',
            options: ['speaks', 'is spoken', 'was spoken', 'has spoken'],
            correctIndex: 1,
            explanation: 'Present simple passive: is/are + V3 → is spoken.',
          ),
          _LessonExercise(
            question: 'Passive structure is:',
            options: ['Subject + V + Object', 'Subject + be + V3', 'Subject + have + V3', 'Subject + be + V-ing'],
            correctIndex: 1,
            explanation: 'Passive: Subject + be + past participle (V3).',
          ),
        ];
      default:
        // Fallback grammar exercises
        return const [
          _LessonExercise(
            question: 'Choose the correct sentence.',
            options: ['He go to school.', 'He goes to school.', 'He going to school.', 'He gone to school.'],
            correctIndex: 1,
            explanation: 'He/She/It in present simple uses V-s.',
          ),
          _LessonExercise(
            question: 'Choose the correct form: “I ____ a book now.”',
            options: ['read', 'am reading', 'reads', 'have read'],
            correctIndex: 1,
            explanation: 'Now → present continuous: am/is/are + V-ing.',
          ),
          _LessonExercise(
            question: 'Pick the correct modal: “You ____ be quiet in the library.”',
            options: ['must', 'might', 'can', 'could'],
            correctIndex: 0,
            explanation: 'Must = strong obligation.',
          ),
          _LessonExercise(
            question: 'If I had time, I ____ help you.',
            options: ['will', 'would', 'did', 'have'],
            correctIndex: 1,
            explanation: 'Second conditional: would + V.',
          ),
          _LessonExercise(
            question: 'Passive: “The cake ____ by Tom.”',
            options: ['bakes', 'is baked', 'baked', 'is baking'],
            correctIndex: 1,
            explanation: 'Passive uses be + V3.',
          ),
        ];
    }
  }

  // Other skills: basic non-vocabulary placeholder (avoid “Hello”)
  return const [
    _LessonExercise(
      question: 'This lesson content is coming soon.',
      options: ['OK', 'OK', 'OK', 'OK'],
      correctIndex: 0,
      explanation: 'Coming soon.',
    ),
    _LessonExercise(
      question: 'This lesson content is coming soon.',
      options: ['OK', 'OK', 'OK', 'OK'],
      correctIndex: 0,
      explanation: 'Coming soon.',
    ),
    _LessonExercise(
      question: 'This lesson content is coming soon.',
      options: ['OK', 'OK', 'OK', 'OK'],
      correctIndex: 0,
      explanation: 'Coming soon.',
    ),
    _LessonExercise(
      question: 'This lesson content is coming soon.',
      options: ['OK', 'OK', 'OK', 'OK'],
      correctIndex: 0,
      explanation: 'Coming soon.',
    ),
    _LessonExercise(
      question: 'This lesson content is coming soon.',
      options: ['OK', 'OK', 'OK', 'OK'],
      correctIndex: 0,
      explanation: 'Coming soon.',
    ),
  ];
}


