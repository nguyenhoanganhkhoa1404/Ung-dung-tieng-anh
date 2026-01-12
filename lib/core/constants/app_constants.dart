class AppConstants {
  // App info
  static const String appName = 'Ứng Dụng Học Tiếng Anh';
  static const String appVersion = '1.0.0';
  
  // API
  static const String apiBaseUrl = 'https://api.ungdunghoctiengcanh.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Levels
  static const List<String> englishLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
  
  // Spaced Repetition intervals (in days)
  static const List<int> spacedRepetitionIntervals = [1, 3, 7, 14, 30, 60, 120];
  
  // Gamification
  static const int xpPerLesson = 10;
  static const int xpPerCorrectAnswer = 5;
  static const int xpPerStreak = 20;
  static const int xpToLevelUp = 100;
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);
  
  // Local storage keys
  static const String keyUserId = 'user_id';
  static const String keyUserLevel = 'user_level';
  static const String keyStreak = 'streak_days';
  static const String keyLastStudyDate = 'last_study_date';
  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyLanguage = 'language';
  
  // Firestore collections
  static const String usersCollection = 'users';
  static const String lessonsCollection = 'lessons';
  static const String vocabularyCollection = 'vocabulary';
  static const String grammarCollection = 'grammar';
  static const String achievementsCollection = 'achievements';
  static const String userProgressCollection = 'user_progress';
  
  // Hive boxes
  static const String vocabularyBox = 'vocabulary_box';
  static const String lessonsBox = 'lessons_box';
  static const String progressBox = 'progress_box';
  static const String settingsBox = 'settings_box';
  
  // Notification channels
  static const String reminderChannelId = 'reminder_channel';
  static const String achievementChannelId = 'achievement_channel';
}

