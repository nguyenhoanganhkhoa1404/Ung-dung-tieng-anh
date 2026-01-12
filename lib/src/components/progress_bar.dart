import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../config/app_config.dart';

/// Reusable Progress Bar Component
class ProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showPercentage;
  final String? label;
  
  const ProgressBar({
    super.key,
    required this.progress,
    this.height = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.showPercentage = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ?? 
        (isDark ? Colors.grey[800] : Colors.grey[200]);
    final progColor = progressColor ?? LingoFlowColors.oceanBlue;
    final clampedProgress = progress.clamp(0.0, 1.0);
    
    Widget progressWidget = ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: clampedProgress,
        minHeight: height,
        backgroundColor: bgColor,
        valueColor: AlwaysStoppedAnimation<Color>(progColor),
      ),
    );
    
    if (AppConfig.enableProgressBarAnimation) {
      progressWidget = TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: clampedProgress),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: LinearProgressIndicator(
              value: value,
              minHeight: height,
              backgroundColor: bgColor,
              valueColor: AlwaysStoppedAnimation<Color>(progColor),
            ),
          );
        },
      );
    }
    
    if (label != null || showPercentage) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (showPercentage)
                    Text(
                      '${(clampedProgress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
          progressWidget,
        ],
      );
    }
    
    return progressWidget;
  }
}


