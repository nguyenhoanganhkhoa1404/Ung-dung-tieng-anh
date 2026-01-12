import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'listening_type_page.dart';

/// Trang Listening - Luyện nghe
class ListeningPage extends StatelessWidget {
  final String userId;

  const ListeningPage({
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
          'Listening',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF4CAF50),
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

            // Levels Section - FROM EASY TO HARD
            Text(
              '📊 By Level (Easy to Hard)',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),

            // Level Cards
            _buildTypeCard(
              context,
              title: 'A1 - Beginner',
              subtitle: 'Simple dialogues • Basic vocabulary • Slow speech',
              icon: Icons.looks_one_outlined,
              color: const Color(0xFF66BB6A),
              progress: 0,
            ),
            _buildTypeCard(
              context,
              title: 'A2 - Elementary',
              subtitle: 'Daily conversations • Directions • Descriptions',
              icon: Icons.looks_two_outlined,
              color: const Color(0xFF4CAF50),
              progress: 0,
            ),
            _buildTypeCard(
              context,
              title: 'B1 - Intermediate',
              subtitle: 'Travel • Work discussions • Longer passages',
              icon: Icons.looks_3_outlined,
              color: const Color(0xFF43A047),
              progress: 0,
            ),
            _buildTypeCard(
              context,
              title: 'B2 - Upper Intermediate',
              subtitle: 'Complex topics • Arguments • Academic style',
              icon: Icons.looks_4_outlined,
              color: const Color(0xFF388E3C),
              progress: 0,
            ),
            _buildTypeCard(
              context,
              title: 'C1 - Advanced',
              subtitle: 'Business • Lectures • Abstract concepts',
              icon: Icons.looks_5_outlined,
              color: const Color(0xFF2E7D32),
              progress: 0,
            ),
            _buildTypeCard(
              context,
              title: 'C2 - Proficiency',
              subtitle: 'Academic discussions • Philosophy • Complex arguments',
              icon: Icons.looks_6_outlined,
              color: const Color(0xFF1B5E20),
              progress: 0,
            ),

            const SizedBox(height: 32),

            // Types Section
            Text(
              '🎧 By Type',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),

            // Type List
            _buildTypeCard(
              context,
              title: 'Hội thoại ngắn',
              subtitle: 'Daily conversations • 30–60s • 5–6 questions',
              icon: Icons.people_outline,
              color: const Color(0xFF4CAF50),
              progress: 0,
            ),
            _buildTypeCard(
              context,
              title: 'Hội thoại dài',
              subtitle: 'Booking • Interview • Discussion • 1–2 min',
              icon: Icons.forum_outlined,
              color: const Color(0xFF43A047),
              progress: 0,
            ),
            _buildTypeCard(
              context,
              title: 'Bản tin / thông báo',
              subtitle: 'News • Public announcements • 30–90s',
              icon: Icons.newspaper,
              color: const Color(0xFF2E7D32),
              progress: 0,
            ),
            _buildTypeCard(
              context,
              title: 'Câu chuyện kể',
              subtitle: 'Storytelling • Personal experiences • 1–2 min',
              icon: Icons.auto_stories_outlined,
              color: const Color(0xFF1B5E20),
              progress: 0,
            ),
            _buildTypeCard(
              context,
              title: 'Bài giảng ngắn',
              subtitle: 'Education • Science • Society • 2–3 min',
              icon: Icons.school_outlined,
              color: const Color(0xFF00897B),
              progress: 0,
            ),
            _buildTypeCard(
              context,
              title: 'Thông báo (sân bay/trường/công ty)',
              subtitle: 'Airport • School • Company • 30–90s',
              icon: Icons.campaign_outlined,
              color: const Color(0xFF00796B),
              progress: 0,
            ),
            _buildTypeCard(
              context,
              title: 'Phỏng vấn',
              subtitle: 'Interviews • Career advice • 2–3 min',
              icon: Icons.badge_outlined,
              color: const Color(0xFF00695C),
              progress: 0,
            ),
            _buildTypeCard(
              context,
              title: 'Podcast ngắn',
              subtitle: 'Tips • Health • Learning • 1–2 min',
              icon: Icons.podcasts,
              color: const Color(0xFF26A69A),
              progress: 0,
            ),

            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return GFCard(
      boxFit: BoxFit.cover,
      color: const Color(0xFF4CAF50),
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
                Icons.headphones_outlined,
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
                    'Listening',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Improve your listening skills',
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

  Widget _buildTypeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int progress,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ListeningTypePage(
              userId: userId,
              typeTitle: title,
              subtitle: subtitle,
              icon: icon,
              color: color,
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
