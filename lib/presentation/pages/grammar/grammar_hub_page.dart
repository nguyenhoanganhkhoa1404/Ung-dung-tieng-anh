import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/datasources/local/grammar_question_bank.dart';
import 'practice_quiz_page.dart';

/// Hub page: Grammar categories (CEFR + topics)
/// Each item opens PracticeQuizPage (random 5 from that category bank)
class GrammarHubPage extends StatelessWidget {
  const GrammarHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFFF6584);

    final sections = <_Section>[
      _Section(
        title: 'CEFR Grammar',
        items: [
          _Item(
            title: 'A1 – A2 (Cơ bản)',
            subtitle: '~20–30 grammar',
            icon: Icons.looks_one_rounded,
            bank: GrammarQuestionBank.grammarA1A2Basic(),
          ),
          _Item(
            title: 'B1 (Trung cấp)',
            subtitle: '~25–30 grammar',
            icon: Icons.looks_two_rounded,
            bank: GrammarQuestionBank.grammarB1(),
          ),
          _Item(
            title: 'B2 (Trung cao)',
            subtitle: '~20–25 grammar',
            icon: Icons.looks_3_rounded,
            bank: GrammarQuestionBank.grammarB2(),
          ),
          _Item(
            title: 'C1 – C2 (Nâng cao)',
            subtitle: '~15–20 grammar',
            icon: Icons.looks_4_rounded,
            bank: GrammarQuestionBank.grammarC1C2(),
          ),
        ],
      ),
      _Section(
        title: 'Chuyên đề',
        items: [
          _Item(
            title: 'Câu điều kiện (Conditionals)',
            subtitle: '4–5 câu',
            icon: Icons.alt_route_rounded,
            bank: GrammarQuestionBank.conditionals(),
          ),
          _Item(
            title: 'Bị động (Passive Voice)',
            subtitle: '4–6 câu',
            icon: Icons.swap_horiz_rounded,
            bank: GrammarQuestionBank.passiveVoice(),
          ),
          _Item(
            title: 'Mệnh đề (Clauses)',
            subtitle: '10+ câu (relative / noun / adverb)',
            icon: Icons.account_tree_rounded,
            bank: GrammarQuestionBank.clauses(),
          ),
          _Item(
            title: 'Modal Verbs',
            subtitle: '10+ câu',
            icon: Icons.rule_rounded,
            bank: GrammarQuestionBank.modalVerbs(),
          ),
          _Item(
            title: 'Gerund / Infinitive',
            subtitle: '10+ câu',
            icon: Icons.text_fields_rounded,
            bank: GrammarQuestionBank.gerundInfinitive(),
          ),
          _Item(
            title: 'So sánh (Comparisons)',
            subtitle: '10+ câu',
            icon: Icons.compare_arrows_rounded,
            bank: GrammarQuestionBank.comparisons(),
          ),
          _Item(
            title: 'Câu gián tiếp (Reported Speech)',
            subtitle: '10+ câu',
            icon: Icons.record_voice_over_rounded,
            bank: GrammarQuestionBank.reportedSpeech(),
          ),
          _Item(
            title: 'Đảo ngữ / Nhấn mạnh',
            subtitle: '10+ câu',
            icon: Icons.bolt_rounded,
            bank: GrammarQuestionBank.inversionEmphasis(),
          ),
        ],
      ),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[50];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Grammar',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeader(color),
          const SizedBox(height: 18),
          ...sections.expand((s) => _buildSection(context, s, color)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHeader(Color color) {
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
            child: const Icon(Icons.school_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grammar Practice',
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

  List<Widget> _buildSection(BuildContext context, _Section section, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sectionColor = isDark ? Colors.white : const Color(0xFF111827);

    return [
      Text(
        section.title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: sectionColor,
        ),
      ),
      const SizedBox(height: 10),
      ...section.items.map((it) => _buildCard(context, it, color)),
      const SizedBox(height: 16),
    ];
  }

  Widget _buildCard(BuildContext context, _Item item, Color color) {
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

class _Section {
  final String title;
  final List<_Item> items;

  const _Section({required this.title, required this.items});
}

class _Item {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<PracticeQuestion> bank;

  const _Item({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bank,
  });
}


