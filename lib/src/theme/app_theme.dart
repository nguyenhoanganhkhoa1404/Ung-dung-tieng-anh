import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import '../config/app_config.dart';

/// LingoFlow App Theme
/// Combines colors and typography with Ocean Blue #2A67FF and Poppins font
class LingoFlowTheme {
  static ThemeData get lightTheme {
    if (!AppConfig.useLingoFlowTheme) {
      // Fallback to existing theme
      return ThemeData.light();
    }
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: LingoFlowColors.oceanBlue,
      scaffoldBackgroundColor: LingoFlowColors.backgroundColor,
      colorScheme: ColorScheme.light(
        primary: LingoFlowColors.oceanBlue,
        secondary: LingoFlowColors.softCoral,
        surface: LingoFlowColors.cardBackground,
        error: LingoFlowColors.errorColor,
      ),
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: LingoFlowColors.oceanBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      
      // Card theme with 24px border radius
      cardTheme: CardThemeData(
        color: LingoFlowColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        ),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LingoFlowColors.oceanBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          ),
          elevation: 2,
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: LingoFlowColors.oceanBlue,
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          borderSide: BorderSide(color: LingoFlowColors.oceanBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          borderSide: const BorderSide(color: LingoFlowColors.errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Text theme using Poppins
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: LingoFlowColors.textPrimary,
          fontFamily: LingoFlowTypography.fontFamily,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: LingoFlowColors.textPrimary,
          fontFamily: LingoFlowTypography.fontFamily,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: LingoFlowColors.textPrimary,
          fontFamily: LingoFlowTypography.fontFamily,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: LingoFlowColors.textPrimary,
          fontFamily: LingoFlowTypography.fontFamily,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: LingoFlowColors.textPrimary,
          fontFamily: LingoFlowTypography.fontFamily,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: LingoFlowColors.textPrimary,
          fontFamily: LingoFlowTypography.fontFamily,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: LingoFlowColors.textSecondary,
          fontFamily: LingoFlowTypography.fontFamily,
        ),
      ),
      
      // Icon theme
      iconTheme: IconThemeData(
        color: LingoFlowColors.oceanBlue,
        size: 24,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    if (!AppConfig.useLingoFlowTheme) {
      // Fallback to existing theme
      return ThemeData.dark();
    }
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: LingoFlowColors.oceanBlue,
      scaffoldBackgroundColor: LingoFlowColors.darkBackground,
      colorScheme: ColorScheme.dark(
        primary: LingoFlowColors.oceanBlue,
        secondary: LingoFlowColors.softCoral,
        surface: LingoFlowColors.darkCardBackground,
        error: LingoFlowColors.errorColor,
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: LingoFlowColors.darkCardBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
      
      cardTheme: CardThemeData(
        color: LingoFlowColors.darkCardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LingoFlowColors.oceanBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          ),
          elevation: 2,
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: LingoFlowColors.oceanBlue,
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LingoFlowColors.darkCardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
         focusedBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(AppConfig.borderRadius),
           borderSide: BorderSide(color: LingoFlowColors.oceanBlue, width: 2),
         ),
         errorBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(AppConfig.borderRadius),
           borderSide: const BorderSide(color: LingoFlowColors.errorColor),
         ),
         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
       ),
       
       textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: LingoFlowTypography.fontFamily,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: LingoFlowTypography.fontFamily,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: LingoFlowTypography.fontFamily,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: LingoFlowTypography.fontFamily,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: LingoFlowTypography.fontFamily,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontFamily: LingoFlowTypography.fontFamily,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.grey[400],
          fontFamily: LingoFlowTypography.fontFamily,
        ),
      ),
      
      iconTheme: IconThemeData(
        color: LingoFlowColors.oceanBlue,
        size: 24,
      ),
    );
  }
}

