import 'package:flutter/material.dart';
import '../config/app_config.dart';

/// LingoFlow Color Theme
/// Ocean Blue #2A67FF, Soft Coral, white, gray
class LingoFlowColors {
  // Primary Colors - làm ấm và dịu hơn
  static Color get oceanBlue => Color(AppConfig.primaryColorValue);
  static const Color softCoral = Color(0xFFFF7BA3); // Làm ấm hơn một chút
  static const Color white = Colors.white;
  static const Color gray = Color(0xFF9094A6);
  static const Color grayLight = Color(0xFFF5F7FA);
  static const Color grayDark = Color(0xFF2D3142);
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkCardBackground = Color(0xFF16213E);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF9094A6);
  static const Color textLight = Colors.white;
  
  // Status Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53935);
  static const Color warningColor = Color(0xFFFFA726);
  static const Color infoColor = Color(0xFF29B6F6);
  
  // Streak & Achievement Colors
  static const Color streakFire = Color(0xFFFF6F00);
  static const Color goldColor = Color(0xFFFFD700);
  static const Color silverColor = Color(0xFFC0C0C0);
  static const Color bronzeColor = Color(0xFFCD7F32);
  
  // AI Chat Colors
  static const Color aiBubbleLight = Color(0xFFE3F2FD);
  static const Color userBubbleBorder = Color(0xFF2A67FF);
  static const Color grammarHighlight = Color(0xFFFFF9C4);
}


