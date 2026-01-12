import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống Kê'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCard(context),
            const SizedBox(height: 24),
            _buildSkillsProgress(context),
            const SizedBox(height: 24),
            _buildWeeklyActivity(context),
            const SizedBox(height: 24),
            _buildAchievements(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng quan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context,
                  icon: Icons.star,
                  value: '1,250',
                  label: 'XP',
                  color: AppColors.goldColor,
                ),
                _buildStatColumn(
                  context,
                  icon: Icons.local_fire_department,
                  value: '5',
                  label: 'Streak',
                  color: AppColors.streakFire,
                ),
                _buildStatColumn(
                  context,
                  icon: Icons.access_time,
                  value: '12h',
                  label: 'Học tập',
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSkillsProgress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiến độ kỹ năng',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSkillProgressBar('Từ vựng', 0.75, AppColors.vocabularyColor),
                const SizedBox(height: 12),
                _buildSkillProgressBar('Ngữ pháp', 0.60, AppColors.grammarColor),
                const SizedBox(height: 12),
                _buildSkillProgressBar('Nghe', 0.45, AppColors.listeningColor),
                const SizedBox(height: 12),
                _buildSkillProgressBar('Nói', 0.30, AppColors.speakingColor),
                const SizedBox(height: 12),
                _buildSkillProgressBar('Đọc', 0.55, AppColors.readingColor),
                const SizedBox(height: 12),
                _buildSkillProgressBar('Viết', 0.40, AppColors.writingColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillProgressBar(String skill, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(skill),
            Text('${(progress * 100).toInt()}%'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          minHeight: 8,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildWeeklyActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hoạt động tuần này',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDayActivity('T2', true),
                _buildDayActivity('T3', true),
                _buildDayActivity('T4', true),
                _buildDayActivity('T5', false),
                _buildDayActivity('T6', false),
                _buildDayActivity('T7', false),
                _buildDayActivity('CN', false),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayActivity(String day, bool completed) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: completed
                ? AppColors.successColor
                : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Icon(
            completed ? Icons.check : Icons.close,
            color: completed ? Colors.white : Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            color: completed ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thành tựu gần đây',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildAchievementBadge(
                icon: Icons.emoji_events,
                title: 'Thành tựu ${index + 1}',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementBadge({
    required IconData icon,
    required String title,
  }) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.goldColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

