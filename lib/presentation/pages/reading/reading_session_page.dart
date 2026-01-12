import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/local/reading_exercise_bank.dart';
import '../../../data/repositories/analytics_repository_impl.dart';
import '../../../domain/entities/learning_session_entity.dart';

/// Practice page for ONE reading passage:
/// - shows passage
/// - 6–8 MCQ questions
/// - result summary + save to Firestore (exercise_results + learning_sessions)
class ReadingSessionPage extends StatefulWidget {
  final String userId;
  final ReadingPassage passage;
  final Color color;

  const ReadingSessionPage({
    super.key,
    required this.userId,
    required this.passage,
    required this.color,
  });

  @override
  State<ReadingSessionPage> createState() => _ReadingSessionPageState();
}

class _ReadingSessionPageState extends State<ReadingSessionPage> {
  late final AnalyticsRepositoryImpl _repo;
  String? _sessionId;
  bool _persisted = false;

  int _index = 0;
  bool _showResult = false;
  final Map<int, int> _answers = {}; // qIndex -> selectedIndex

  @override
  void initState() {
    super.initState();
    _repo = AnalyticsRepositoryImpl();
    Future.microtask(_startSessionIfPossible);
  }

  Future<void> _startSessionIfPossible() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? widget.userId;
    try {
      _sessionId = await _repo.startLearningSession(
        userId: uid,
        skill: SkillType.reading,
        lessonId: 'reading:${widget.passage.category}:${widget.passage.id}',
      );
    } catch (_) {}
  }

  ReadingQuestion get _q => widget.passage.questions[_index];

  bool get _isAnswered => _answers.containsKey(_index);

  void _next() {
    if (!_isAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn đáp án trước.')),
      );
      return;
    }
    if (_index < widget.passage.questions.length - 1) {
      setState(() => _index++);
    } else {
      setState(() => _showResult = true);
      _persistResultIfNeeded();
    }
  }

  int _countCorrect() {
    int correct = 0;
    for (var i = 0; i < widget.passage.questions.length; i++) {
      final q = widget.passage.questions[i];
      if (_answers[i] == q.correctIndex) correct++;
    }
    return correct;
  }

  Future<void> _persistResultIfNeeded() async {
    if (_persisted) return;
    _persisted = true;

    final uid = FirebaseAuth.instance.currentUser?.uid ?? widget.userId;
    final total = widget.passage.questions.length;
    final correct = _countCorrect();

    try {
      await _repo.saveExerciseResult(
        userId: uid,
        skill: SkillType.reading,
        correctAnswers: correct,
        totalQuestions: total,
        completed: true,
        lessonId: 'reading:${widget.passage.category}:${widget.passage.id}',
        sessionId: _sessionId,
      );
      if (_sessionId != null) {
        await _repo.completeLearningSession(_sessionId!);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          widget.passage.title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
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
                _showResult
                    ? 'Done'
                    : '${_index + 1}/${widget.passage.questions.length}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: _showResult ? _buildResult() : _buildQuiz(),
        ),
      ),
      bottomNavigationBar: _showResult
          ? null
          : SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _index < widget.passage.questions.length - 1
                          ? 'Next'
                          : 'View Results',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildQuiz() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildPassageCard(),
        const SizedBox(height: 14),
        _buildQuestionCard(_q),
        const SizedBox(height: 12),
        _buildOptions(_q),
        const SizedBox(height: 90),
      ],
    );
  }

  Widget _buildPassageCard() {
    return ExpansionTile(
      initiallyExpanded: true,
      collapsedBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Text(
        'Passage • ${widget.passage.topic}',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        'Đọc đoạn văn rồi trả lời 6–8 câu hỏi',
        style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF6B7280)),
      ),
      children: [
        // Article-style title inside the passage card
        Text(
          widget.passage.title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF111827),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                widget.passage.category,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: widget.color,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.10),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                widget.passage.topic,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SelectableText(
          widget.passage.text,
          textAlign: TextAlign.justify,
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 1.65,
            color: const Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(ReadingQuestion q) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${_index + 1}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: widget.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            q.prompt,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(ReadingQuestion q) {
    final selected = _answers[_index];
    return Column(
      children: List.generate(q.options.length, (i) {
        final isSelected = selected == i;
        return GestureDetector(
          onTap: () => setState(() => _answers[_index] = i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected ? widget.color.withOpacity(0.10) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? widget.color : Colors.grey.withOpacity(0.18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? widget.color
                        : Colors.grey.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    String.fromCharCode(65 + i),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    q.options[i],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildResult() {
    final total = widget.passage.questions.length;
    final correct = _countCorrect();
    final percent = total == 0 ? 0 : ((correct / total) * 100).round();
    final passed = percent >= 60;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.withOpacity(0.12)),
          ),
          child: Column(
            children: [
              Icon(
                passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 72,
                color: passed ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 12),
              Text(
                passed ? 'Great job!' : 'Keep practicing!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$correct / $total correct • $percent%',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Back',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Review (Answers)',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 10),
        ...List.generate(widget.passage.questions.length, (i) {
          final q = widget.passage.questions[i];
          final isCorrect = _answers[i] == q.correctIndex;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (isCorrect ? Colors.green : Colors.red).withOpacity(0.25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Q${i + 1}: ${q.prompt}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Correct: ${q.options[q.correctIndex]}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
                if ((q.explanation ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    q.explanation!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
      ],
    );
  }
}


