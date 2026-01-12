import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/local/writing_prompt_bank.dart';
import '../../../data/repositories/analytics_repository_impl.dart';
import '../../../domain/entities/learning_session_entity.dart';

class WritingSessionPage extends StatefulWidget {
  final String userId;
  final WritingPrompt prompt;
  final Color color;

  const WritingSessionPage({
    super.key,
    required this.userId,
    required this.prompt,
    required this.color,
  });

  @override
  State<WritingSessionPage> createState() => _WritingSessionPageState();
}

class _WritingSessionPageState extends State<WritingSessionPage> {
  late final AnalyticsRepositoryImpl _repo;
  String? _sessionId;
  bool _submitted = false;

  final _controller = TextEditingController();

  // 1..5
  final Map<String, int> _rubric = {
    'Ideas': 3,
    'Structure': 3,
    'Grammar': 3,
    'Vocabulary': 3,
    'Coherence': 3,
    'Task response': 3,
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
        skill: SkillType.writing,
        lessonId: 'writing:${widget.prompt.category}:${widget.prompt.id}',
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _score => _rubric.values.fold<int>(0, (a, b) => a + b); // max 30

  int get _wordCount {
    final t = _controller.text.trim();
    if (t.isEmpty) return 0;
    return t.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  }

  Future<void> _submit() async {
    if (_submitted) return;
    if (_wordCount < 120 || _wordCount > 250) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng viết trong khoảng 120–250 từ.')),
      );
      return;
    }
    setState(() => _submitted = true);

    final uid = FirebaseAuth.instance.currentUser?.uid ?? widget.userId;
    final total = 30;
    final correct = _score.clamp(0, total);

    try {
      await _repo.saveExerciseResult(
        userId: uid,
        skill: SkillType.writing,
        correctAnswers: correct,
        totalQuestions: total,
        completed: true,
        lessonId: 'writing:${widget.prompt.category}:${widget.prompt.id}',
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
        content: Text('Words: $_wordCount • Score: $correct/$total'),
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
          widget.prompt.title,
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
              _buildEditorCard(),
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
            widget.prompt.category,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: widget.color,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
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
            'Requirements',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w900,
              color: widget.color,
            ),
          ),
          const SizedBox(height: 6),
          ...widget.prompt.requirements.map(
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

  Widget _buildEditorCard() {
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
                  'Your writing',
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
                  'Words: $_wordCount',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900,
                    color: widget.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            onChanged: (_) => setState(() {}),
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'Write 120–250 words here…',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tip: Hãy dùng từ nối (however, therefore, moreover…) và ví dụ cụ thể.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFF6B7280),
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


