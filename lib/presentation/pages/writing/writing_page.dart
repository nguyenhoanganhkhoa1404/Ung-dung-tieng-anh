import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'writing_category_page.dart';

/// Trang Writing - Luyện viết
class WritingPage extends StatelessWidget {
  final String userId;

  const WritingPage({
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
          'Writing',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF9C27B0),
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
              'Writing Exercises',
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
              title: 'Miêu tả',
              subtitle: 'Nơi yêu thích • người quan trọng • ngày đặc biệt…',
              icon: Icons.landscape_rounded,
              color: const Color(0xFF9C27B0),
            ),
            _buildCategoryCard(
              context,
              title: 'Kể chuyện',
              subtitle: 'Kỷ niệm • thất bại • chuyến đi đáng nhớ…',
              icon: Icons.auto_stories_rounded,
              color: const Color(0xFF8E24AA),
            ),
            _buildCategoryCard(
              context,
              title: 'Nghị luận – quan điểm',
              subtitle: 'Tiền & hạnh phúc • gia đình • mạng xã hội…',
              icon: Icons.fact_check_rounded,
              color: const Color(0xFF7B1FA2),
            ),
            _buildCategoryCard(
              context,
              title: 'So sánh',
              subtitle: 'Thành phố vs nông thôn • online vs offline…',
              icon: Icons.compare_arrows_rounded,
              color: const Color(0xFF6A1B9A),
            ),
            _buildCategoryCard(
              context,
              title: 'Giải thích',
              subtitle: 'Vì sao học Anh • vì sao đọc sách • lợi ích thể dục…',
              icon: Icons.lightbulb_rounded,
              color: const Color(0xFF5E35B1),
            ),
            _buildCategoryCard(
              context,
              title: 'Thuyết phục',
              subtitle: 'Bảo vệ môi trường • học suốt đời • hoạt động xã hội…',
              icon: Icons.campaign_rounded,
              color: const Color(0xFF512DA8),
            ),
            _buildCategoryCard(
              context,
              title: 'Phản biện',
              subtitle: 'Phản biện ý kiến phổ biến • lập luận + ví dụ',
              icon: Icons.gavel_rounded,
              color: const Color(0xFF4527A0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return GFCard(
      boxFit: BoxFit.cover,
      color: const Color(0xFF9C27B0),
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
                Icons.edit_outlined,
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
                    'Writing',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Master written communication',
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
            builder: (_) => WritingCategoryPage(
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
                  const SizedBox(height: 8),
                  GFProgressBar(
                    percentage: 0,
                    lineHeight: 6,
                    backgroundColor: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                    progressBarColor: color,
                    circleWidth: 0,
                  ),
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
