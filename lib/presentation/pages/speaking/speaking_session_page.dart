import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/local/speaking_prompt_bank.dart';
import '../../../data/repositories/analytics_repository_impl.dart';
import '../../../domain/entities/learning_session_entity.dart';

class SpeakingSessionPage extends StatefulWidget {
  final String userId;
  final SpeakingPrompt prompt;
  final Color color;

  const SpeakingSessionPage({
    super.key,
    required this.userId,
    required this.prompt,
    required this.color,
  });

  @override
  State<SpeakingSessionPage> createState() => _SpeakingSessionPageState();
}

class _SpeakingSessionPageState extends State<SpeakingSessionPage> {
  late final AnalyticsRepositoryImpl _repo;
  String? _sessionId;
  bool _submitted = false;

  Timer? _timer;
  int _seconds = 0;
  bool _running = false;

  // 1..5
  final Map<String, int> _rubric = {
    'Ideas': 3,
    'Pronunciation': 3,
    'Grammar': 3,
    'Vocabulary': 3,
    'Fluency': 3,
    'Development': 3,
  };

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
        skill: SkillType.speaking,
        lessonId: 'speaking:part${widget.prompt.part}:${widget.prompt.id}',
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
      return;
    }
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  String _fmt(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  int get _score => _rubric.values.fold<int>(0, (a, b) => a + b); // max 30

  Future<void> _submit() async {
    if (_submitted) return;
    setState(() => _submitted = true);

    final uid = FirebaseAuth.instance.currentUser?.uid ?? widget.userId;
    final total = 30; // max rubric points
    final correct = _score.clamp(0, total);

    try {
      await _repo.saveExerciseResult(
        userId: uid,
        skill: SkillType.speaking,
        correctAnswers: correct,
        totalQuestions: total,
        completed: true,
        lessonId: 'speaking:part${widget.prompt.part}:${widget.prompt.id}',
        sessionId: _sessionId,
      );
      if (_sessionId != null) {
        await _repo.completeLearningSession(_sessionId!);
      }
    } catch (_) {}

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Saved'),
        content: Text('Score: $correct/$total • Time: ${_fmt(_seconds)}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Speaking Part ${widget.prompt.part}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : widget.color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildPromptCard(),
              const SizedBox(height: 14),
              _buildTimerCard(),
              const SizedBox(height: 14),
              _buildRubricCard(),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submitted ? null : _submit,
              icon: const Icon(Icons.check_circle_rounded),
              label: Text(
                'Submit (Save result)',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromptCard() {
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
            widget.prompt.title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.prompt.prompt,
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.45,
              color: const Color(0xFF111827),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tips',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w900,
              color: widget.color,
            ),
          ),
          const SizedBox(height: 6),
          ...widget.prompt.tips.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: GoogleFonts.poppins(fontWeight: FontWeight.w900)),
                  Expanded(
                    child: Text(
                      t,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.timer_rounded, color: widget.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Speaking Timer',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF111827),
                  ),
                ),
                Text(
                  'Time: ${_fmt(_seconds)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: _toggleTimer,
            icon: Icon(_running ? Icons.pause_rounded : Icons.play_arrow_rounded),
            label: Text(_running ? 'Pause' : 'Start'),
            style: TextButton.styleFrom(
              foregroundColor: widget.color,
              textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRubricCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Self-assessment (1–5)',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Score: $_score/30',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900,
                    color: widget.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._rubric.entries.map((e) => _buildSliderRow(e.key, e.value)),
        ],
      ),
    );
  }

  Widget _buildSliderRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              Text(
                value.toString(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w900,
                  color: widget.color,
                ),
              ),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: value.toString(),
            activeColor: widget.color,
            onChanged: (v) => setState(() => _rubric[label] = v.round()),
          ),
        ],
      ),
    );
  }
}


