import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'reading_category_page.dart';

/// Trang Reading - Luyện đọc
class ReadingPage extends StatelessWidget {
  final String userId;

  const ReadingPage({
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
          'Reading',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2196F3),
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

            // Lessons Section
            Text(
              'Reading Materials',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),

            // Lesson List
            _buildCategoryCard(
              context,
              title: 'Tin tức – báo chí',
              subtitle: 'Khí hậu • Công nghệ • Y tế • Giáo dục • Kinh tế…',
              icon: Icons.newspaper_rounded,
              color: const Color(0xFF2196F3),
              progress: 0,
            ),
            _buildCategoryCard(
              context,
              title: 'Truyện ngắn – câu chuyện',
              subtitle: 'Tình bạn • Gia đình • Tuổi học trò • Một ngày đặc biệt…',
              icon: Icons.auto_stories_rounded,
              color: const Color(0xFF1E88E5),
              progress: 0,
            ),
            _buildCategoryCard(
              context,
              title: 'Miêu tả',
              subtitle: 'Thành phố • Du lịch • Thiên nhiên • Lễ hội • Con người…',
              icon: Icons.location_city_rounded,
              color: const Color(0xFF1976D2),
              progress: 0,
            ),
            _buildCategoryCard(
              context,
              title: 'Phân tích – quan điểm',
              subtitle: 'Mạng xã hội • Công nghệ • Sách • Lối sống…',
              icon: Icons.psychology_rounded,
              color: const Color(0xFF1565C0),
              progress: 0,
            ),
            _buildCategoryCard(
              context,
              title: 'Lịch sử – khoa học',
              subtitle: 'Phát minh • Nhân vật • Internet & AI • Tiến bộ khoa học…',
              icon: Icons.science_rounded,
              color: const Color(0xFF0D47A1),
              progress: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return GFCard(
      boxFit: BoxFit.cover,
      color: const Color(0xFF2196F3),
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
                Icons.auto_stories_outlined,
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
                    'Reading',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enhance reading comprehension',
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

  Widget _buildCategoryCard(
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
            builder: (_) => ReadingCategoryPage(
              userId: userId,
              category: title,
              color: color,
              icon: icon,
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
