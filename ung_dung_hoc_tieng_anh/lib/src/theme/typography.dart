import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// LingoFlow Typography Theme
/// Uses Poppins font family (supports Vietnamese characters)
class LingoFlowTypography {
  // Poppins font family - supports Vietnamese
  static String get fontFamily => 'Poppins';
  
  // Display Styles
  static TextStyle displayLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : LingoFlowColors.textPrimary,
    );
  }
  
  static TextStyle displayMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : LingoFlowColors.textPrimary,
    );
  }
  
  static TextStyle displaySmall(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : LingoFlowColors.textPrimary,
    );
  }
  
  // Headline Styles
  static TextStyle headlineLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : LingoFlowColors.textPrimary,
    );
  }
  
  static TextStyle headlineMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : LingoFlowColors.textPrimary,
    );
  }
  
  // Body Styles
  static TextStyle bodyLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : LingoFlowColors.textPrimary,
    );
  }
  
  static TextStyle bodyMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[400]
          : LingoFlowColors.textSecondary,
    );
  }
  
  static TextStyle bodySmall(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[500]
          : LingoFlowColors.textSecondary,
    );
  }
  
  // Label Styles
  static TextStyle labelLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : LingoFlowColors.textPrimary,
    );
  }
  
  static TextStyle labelMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[400]
          : LingoFlowColors.textSecondary,
    );
  }
  
  static TextStyle labelSmall(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[500]
          : LingoFlowColors.textSecondary,
    );
  }
}

