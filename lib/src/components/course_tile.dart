import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../config/app_config.dart';
import 'progress_bar.dart';

/// Course Tile Component
/// Rounded course card with icon + progress
class CourseTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final double progress; // 0.0 to 1.0
  final VoidCallback? onTap;
  final String? difficulty;
  
  const CourseTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    this.progress = 0.0,
    this.onTap,
    this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? LingoFlowColors.darkCardBackground : Colors.white;
    final textColor = isDark ? Colors.white : LingoFlowColors.textPrimary;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and title row
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          iconColor,
                          iconColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: iconColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: LingoFlowTypography.headlineMedium(context)
                              .copyWith(color: textColor),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: LingoFlowTypography.bodySmall(context),
                          ),
                        ],
                        if (difficulty != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              difficulty!,
                              style: LingoFlowTypography.labelSmall(context)
                                  .copyWith(color: iconColor),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              
              // Progress bar
              if (AppConfig.enableCourseProgress && progress > 0) ...[
                const SizedBox(height: 16),
                ProgressBar(
                  progress: progress,
                  height: 6,
                  progressColor: iconColor,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}% Complete',
                      style: LingoFlowTypography.bodySmall(context),
                    ),
                    if (progress >= 1.0)
                      Icon(
                        Icons.check_circle_rounded,
                        color: LingoFlowColors.successColor,
                        size: 16,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


