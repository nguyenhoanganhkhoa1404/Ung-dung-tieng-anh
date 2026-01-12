import 'package:flutter/material.dart';
import '../../../../domain/entities/learning_session_entity.dart';

/// Card hiển thị tiến độ từng kỹ năng
/// ✅ Dữ liệu THỰC TẾ từ database
class SkillProgressCard extends StatelessWidget {
  final Map<SkillType, double> skillProgress;

  const SkillProgressCard({
    super.key,
    required this.skillProgress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: SkillType.values.map((skill) {
            final progress = skillProgress[skill] ?? 0.0;
            return _buildSkillRow(context, skill, progress);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSkillRow(BuildContext context, SkillType skill, double progress) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percent = (progress * 100).round();
    final textColor = isDark ? Colors.grey[300] : Colors.grey[700];
    final bgColor = isDark ? Colors.grey[800] : Colors.grey[200];
    
    // Màu sắc theo skill
    Color getColor() {
      switch (skill) {
        case SkillType.vocabulary:
          return Colors.blue;
        case SkillType.grammar:
          return Colors.pink;
        case SkillType.listening:
          return Colors.green;
        case SkillType.speaking:
          return Colors.orange;
        case SkillType.reading:
          return Colors.indigo;
        case SkillType.writing:
          return Colors.purple;
      }
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill.displayName,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
              ),
              Text(
                '$percent%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: getColor(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: bgColor,
            valueColor: AlwaysStoppedAnimation<Color>(getColor()),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

