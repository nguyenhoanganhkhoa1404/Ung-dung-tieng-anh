import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/local/grammar_question_bank.dart';
import 'practice_quiz_page.dart';

/// Hub page: 12 English tenses
/// Each item opens a PracticeQuizPage (random 5 questions from that tense bank)
class TensesPage extends StatelessWidget {
  const TensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFEC407A);

    final items = <_TenseItem>[
      _TenseItem(
        title: 'Present Simple',
        subtitle: 'Habits & facts',
        icon: Icons.event_repeat_rounded,
        bank: GrammarQuestionBank.presentSimple(),
      ),
      _TenseItem(
        title: 'Present Continuous',
        subtitle: 'Action happening now',
        icon: Icons.timelapse_rounded,
        bank: GrammarQuestionBank.presentContinuous(),
      ),
      _TenseItem(
        title: 'Present Perfect Simple',
        subtitle: 'Experience / result',
        icon: Icons.check_circle_outline_rounded,
        bank: GrammarQuestionBank.presentPerfectSimple(),
      ),
      _TenseItem(
        title: 'Present Perfect Continuous',
        subtitle: 'Duration up to now',
        icon: Icons.hourglass_top_rounded,
        bank: GrammarQuestionBank.presentPerfectContinuous(),
      ),
      _TenseItem(
        title: 'Past Simple',
        subtitle: 'Finished past action',
        icon: Icons.history_rounded,
        bank: GrammarQuestionBank.pastSimple(),
      ),
      _TenseItem(
        title: 'Past Continuous',
        subtitle: 'Past action in progress',
        icon: Icons.more_time_rounded,
        bank: GrammarQuestionBank.pastContinuous(),
      ),
      _TenseItem(
        title: 'Past Perfect Simple',
        subtitle: 'Earlier past action',
        icon: Icons.done_all_rounded,
        bank: GrammarQuestionBank.pastPerfectSimple(),
      ),
      _TenseItem(
        title: 'Past Perfect Continuous',
        subtitle: 'Duration before past time',
        icon: Icons.hourglass_bottom_rounded,
        bank: GrammarQuestionBank.pastPerfectContinuous(),
      ),
      _TenseItem(
        title: 'Future Simple',
        subtitle: 'Will + V',
        icon: Icons.trending_up_rounded,
        bank: GrammarQuestionBank.futureSimple(),
      ),
      _TenseItem(
        title: 'Future Continuous',
        subtitle: 'Will be + V-ing',
        icon: Icons.schedule_rounded,
        bank: GrammarQuestionBank.futureContinuous(),
      ),
      _TenseItem(
        title: 'Future Perfect Simple',
        subtitle: 'Will have + V3',
        icon: Icons.flag_circle_rounded,
        bank: GrammarQuestionBank.futurePerfectSimple(),
      ),
      _TenseItem(
        title: 'Future Perfect Continuous',
        subtitle: 'Will have been + V-ing',
        icon: Icons.auto_graph_rounded,
        bank: GrammarQuestionBank.futurePerfectContinuous(),
      ),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[50];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Tenses',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeader(context, color),
          const SizedBox(height: 18),
          ...items.map((it) => _buildCard(context, it, color)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.schedule_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '12 English Tenses',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mỗi mục sẽ random 5 câu để luyện tập.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, _TenseItem item, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor = isDark ? Colors.grey[400] : const Color(0xFF6B7280);
    final count = item.bank.length;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PracticeQuizPage(
              title: item.title,
              subtitle: '${item.subtitle} • Bank: $count • Random 5',
              icon: item.icon,
              color: color,
              questionBank: item.bank,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(isDark ? 0.2 : 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.subtitle} • $count câu',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: isDark ? Colors.grey[600] : Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

class _TenseItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<PracticeQuestion> bank;

  const _TenseItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bank,
  });
}


