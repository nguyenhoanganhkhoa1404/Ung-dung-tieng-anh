import 'package:flutter/material.dart';
import '../../../../domain/entities/learning_session_entity.dart';
import '../../../../domain/services/analytics_service.dart';

/// Card hiển thị kỹ năng yếu cần cải thiện
/// AI phát hiện tự động từ dữ liệu THỰC TẾ
class WeakSkillsCard extends StatelessWidget {
  final List<SkillWeakness> weakSkills;

  const WeakSkillsCard({
    super.key,
    required this.weakSkills,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI phát hiện',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...weakSkills.map((weakness) => _buildWeaknessRow(weakness)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaknessRow(SkillWeakness weakness) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  weakness.skill.displayName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${weakness.accuracyPercent}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '💡 ${weakness.recommendedPractice}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}

