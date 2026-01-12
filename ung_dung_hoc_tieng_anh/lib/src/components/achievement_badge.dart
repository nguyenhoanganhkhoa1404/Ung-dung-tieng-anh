import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../config/app_config.dart';

/// Achievement Badge Component
/// Badge/medal component for achievements
class AchievementBadge extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final VoidCallback? onTap;
  
  const AchievementBadge({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? LingoFlowColors.darkCardBackground : Colors.white;
    final opacity = isUnlocked ? 1.0 : 0.5;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isUnlocked ? onTap : null,
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        child: Opacity(
          opacity: opacity,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
              border: Border.all(
                color: isUnlocked
                    ? color.withOpacity(0.3)
                    : (isDark ? Colors.grey[800]! : Colors.grey.withOpacity(0.1)),
                width: isUnlocked ? 2 : 1,
              ),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.2)
                            : Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Badge icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isUnlocked
                          ? [
                              color,
                              color.withOpacity(0.8),
                            ]
                          : [
                              Colors.grey[400]!,
                              Colors.grey[600]!,
                            ],
                    ),
                    boxShadow: isUnlocked
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: LingoFlowTypography.labelLarge(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // Description
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    textAlign: TextAlign.center,
                    style: LingoFlowTypography.bodySmall(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                // Unlocked indicator
                if (isUnlocked) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: LingoFlowColors.successColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Unlocked',
                        style: LingoFlowTypography.bodySmall(context)
                            .copyWith(color: LingoFlowColors.successColor),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}


