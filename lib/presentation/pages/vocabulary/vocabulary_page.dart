import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'vocabulary_level_page.dart';

/// Trang Vocabulary - Học từ vựng
class VocabularyPage extends StatelessWidget {
  final String userId;

  const VocabularyPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[50];
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Vocabulary',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(),
            const SizedBox(height: 24),

            // Levels Section
            Text(
              'Learning Levels',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),

            // Level List - A1 to C2
            _buildLessonCard(
              context,
              'A1 - Beginner',
              '1,374 words • Basic vocabulary',
              Icons.looks_one,
              const Color(0xFF4CAF50),
              0,
              'A1',
            ),
            _buildLessonCard(
              context,
              'A2 - Elementary',
              '895 words • Common expressions',
              Icons.looks_two,
              const Color(0xFF66BB6A),
              0,
              'A2',
            ),
            _buildLessonCard(
              context,
              'B1 - Intermediate',
              '842 words • Everyday topics',
              Icons.looks_3,
              const Color(0xFF2196F3),
              0,
              'B1',
            ),
            _buildLessonCard(
              context,
              'B2 - Upper Intermediate',
              '367 words • Complex ideas',
              Icons.looks_4,
              const Color(0xFF1976D2),
              0,
              'B2',
            ),
            _buildLessonCard(
              context,
              'C1 - Advanced',
              '1,255 words • Professional use',
              Icons.looks_5,
              const Color(0xFFFF9800),
              0,
              'C1',
            ),
            _buildLessonCard(
              context,
              'C2 - Mastery',
              '2,024 words • Native-like fluency',
              Icons.looks_6,
              const Color(0xFFF57C00),
              0,
              'C2',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return GFCard(
      boxFit: BoxFit.cover,
      color: const Color(0xFF6C63FF),
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
              child: const Icon(
                Icons.book_outlined,
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
                    'Vocabulary',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Master English words',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
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

  Widget _buildLessonCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    int progress,
    String level,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VocabularyLevelPage(
              level: level,
              levelTitle: title,
              userId: userId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: subtitleColor,
                    ),
                  ),
                  if (progress > 0) ...[
                    const SizedBox(height: 8),
                    GFProgressBar(
                      percentage: progress / 100,
                      lineHeight: 6,
                      backgroundColor: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                      progressBarColor: color,
                      circleWidth: 0,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
