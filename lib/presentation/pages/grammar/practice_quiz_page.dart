import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/datasources/local/grammar_question_bank.dart';
import '../../../data/repositories/analytics_repository_impl.dart';
import '../../../domain/entities/learning_session_entity.dart';

/// Generic practice quiz page
/// - receives a question bank
/// - randomly picks 5 questions each session
class PracticeQuizPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<PracticeQuestion> questionBank;

  const PracticeQuizPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.questionBank,
  });

  @override
  State<PracticeQuizPage> createState() => _PracticeQuizPageState();
}

class _PracticeQuizPageState extends State<PracticeQuizPage> {
  late final List<PracticeQuestion> _quiz;
  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;
  bool _showResult = false;
  bool _persisted = false;
  late final AnalyticsRepositoryImpl _repo;
  String? _sessionId;

  @override
  void initState() {
    super.initState();
    _quiz = _pickFive(widget.questionBank);
    _repo = AnalyticsRepositoryImpl();
    Future.microtask(_startSessionIfPossible);
  }

  Future<void> _startSessionIfPossible() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      _sessionId = await _repo.startLearningSession(
        userId: uid,
        skill: SkillType.grammar,
        lessonId: 'grammar:${widget.title}',
      );
    } catch (_) {
      // Ignore tracking failures (should not block learning)
    }
  }

  List<PracticeQuestion> _pickFive(List<PracticeQuestion> bank) {
    final list = List<PracticeQuestion>.from(bank);
    list.shuffle(Random());
    return list.take(5).toList();
  }

  void _select(int i) {
    if (_answered) return;
    setState(() {
      _selected = i;
      _answered = true;
      if (i == _quiz[_index].correctIndex) _score += 20;
    });
  }

  void _next() {
    if (!_answered) {
      GFToast.showToast(
        'Select an answer first!',
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
      return;
    }
    if (_index < _quiz.length - 1) {
      setState(() {
        _index++;
        _selected = null;
        _answered = false;
      });
    } else {
      setState(() {
        _showResult = true;
      });
      _persistResultIfNeeded();
    }
  }

  Future<void> _persistResultIfNeeded() async {
    if (_persisted) return;
    _persisted = true;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final correctAnswers = (_score ~/ 20).clamp(0, _quiz.length);

    try {
      await _repo.saveExerciseResult(
        userId: uid,
        skill: SkillType.grammar,
        correctAnswers: correctAnswers,
        totalQuestions: _quiz.length,
        completed: true,
        lessonId: 'grammar:${widget.title}',
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[50];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : widget.color,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_index + 1}/${_quiz.length}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _showResult ? _buildResult() : _buildQuiz(),
      ),
      bottomNavigationBar: _showResult
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: GFButton(
                  onPressed: _next,
                  text: _index < _quiz.length - 1 ? 'Next' : 'View Results',
                  color: widget.color,
                  size: GFSize.LARGE,
                  fullWidthButton: true,
                  shape: GFButtonShape.pills,
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildQuiz() {
    final q = _quiz[_index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GFCard(
          boxFit: BoxFit.cover,
          color: widget.color,
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.icon, size: 34, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '$_score',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        _buildProgress(),
        const SizedBox(height: 14),
        _buildQuestionCard(q),
        const SizedBox(height: 14),
        ...List.generate(q.options.length, (i) => _buildOption(q, i)),
        if (_answered) ...[
          const SizedBox(height: 14),
          _buildExplanation(q),
        ],
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildProgress() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GFProgressBar(
      percentage: (_index + 1) / _quiz.length,
      lineHeight: 10,
      backgroundColor: isDark ? Colors.grey[800]! : Colors.grey[200]!,
      progressBarColor: widget.color,
      circleWidth: 0,
    );
  }

  Widget _buildQuestionCard(PracticeQuestion q) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final questionColor = isDark ? Colors.white : const Color(0xFF111827);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : widget.color.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${_index + 1}',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: widget.color,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            q.question,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: questionColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(PracticeQuestion q, int i) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selected == i;
    final isCorrect = i == q.correctIndex;

    Color border = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    Color bg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    IconData? icon;
    Color? iconColor;

    if (_answered) {
      if (isSelected) {
        if (isCorrect) {
          border = Colors.green;
          bg = Colors.green.withOpacity(0.08);
          icon = Icons.check_circle;
          iconColor = Colors.green;
        } else {
          border = Colors.red;
          bg = Colors.red.withOpacity(0.08);
          icon = Icons.cancel;
          iconColor = Colors.red;
        }
      } else if (isCorrect) {
        border = Colors.green.withOpacity(0.35);
      }
    } else if (isSelected) {
      border = widget.color;
      bg = widget.color.withOpacity(0.08);
    }

    return GestureDetector(
      onTap: () => _select(i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: border.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                String.fromCharCode(65 + i),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  color: border,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                q.options[i],
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
            ),
            if (icon != null) Icon(icon, color: iconColor),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanation(PracticeQuestion q) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final correct = _selected == q.correctIndex;
    final color = correct ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(correct ? Icons.check_circle : Icons.info_outline, color: color),
              const SizedBox(width: 8),
              Text(
                correct ? 'Correct' : 'Explanation',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            q.explanation,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDark ? Colors.grey[300] : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black;
    final passed = _score >= 60;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : widget.color.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            passed ? Icons.check_circle : Icons.cancel,
            color: passed ? Colors.green : Colors.red,
            size: 72,
          ),
          const SizedBox(height: 10),
          Text(
            passed ? 'Great job!' : 'Keep practicing!',
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: titleColor),
          ),
          const SizedBox(height: 6),
          Text(
            'Score',
            style: GoogleFonts.poppins(color: isDark ? Colors.grey[400] : Colors.grey[600]),
          ),
          const SizedBox(height: 6),
          Text(
            '$_score / 100',
            style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: widget.color,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GFButton(
                  onPressed: () {
                    setState(() {
                      _index = 0;
                      _score = 0;
                      _selected = null;
                      _answered = false;
                      _showResult = false;
                      _quiz
                        ..clear()
                        ..addAll(_pickFive(widget.questionBank));
                    });
                  },
                  text: 'Random 5 again',
                  color: Colors.grey,
                  shape: GFButtonShape.pills,
                  size: GFSize.LARGE,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GFButton(
                  onPressed: () => Navigator.pop(context),
                  text: 'Done',
                  color: widget.color,
                  shape: GFButtonShape.pills,
                  size: GFSize.LARGE,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


