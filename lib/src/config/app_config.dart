/// App Configuration - Toggleable settings for LingoFlow structure
class AppConfig {
  // Theme Configuration
  static const bool useLingoFlowTheme = true; // Toggle between old and new theme
  static const String primaryColorHex = '#2A67FF'; // Ocean Blue
  static const String softCoralHex = '#FF6B9D';
  static const double borderRadius = 24.0; // Rounded corners
  static const String fontFamily = 'Poppins'; // Poppins font - supports Vietnamese
  
  // Navigation Configuration
  static const bool useLingoFlowNavigation = true; // Toggle navigation structure
  static const int bottomNavBarItemCount = 4; // Home, Library, AI Chat, Profile
  
  // Component Configuration
  static const bool useLingoFlowComponents = true; // Toggle component structure
  static const bool enableFlashcardAnimation = true;
  static const bool enableProgressBarAnimation = true;
  
  // Screen Configuration
  static const bool useLingoFlowScreens = true; // Toggle screen structure
  static const bool showStreakCounter = true;
  static const bool showAchievementBadges = true;
  
  // Feature Toggles
  static const bool enableAIChat = true;
  static const bool enableLibrarySearch = true;
  static const bool enableCourseProgress = true;
  
  // Get primary color
  static int get primaryColorValue => int.parse(primaryColorHex.replaceFirst('#', '0xFF'));
  
  // Get soft coral color
  static int get softCoralValue => int.parse(softCoralHex.replaceFirst('#', '0xFF'));
}


