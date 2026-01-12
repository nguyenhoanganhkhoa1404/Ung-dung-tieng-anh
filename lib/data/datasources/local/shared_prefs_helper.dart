import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

class SharedPrefsHelper {
  final SharedPreferences _prefs;
  
  SharedPrefsHelper(this._prefs);
  
  // User ID
  Future<void> setUserId(String userId) async {
    await _prefs.setString(AppConstants.keyUserId, userId);
  }
  
  String? getUserId() {
    return _prefs.getString(AppConstants.keyUserId);
  }
  
  // User Level
  Future<void> setUserLevel(String level) async {
    await _prefs.setString(AppConstants.keyUserLevel, level);
  }
  
  String? getUserLevel() {
    return _prefs.getString(AppConstants.keyUserLevel);
  }
  
  // Streak
  Future<void> setStreak(int days) async {
    await _prefs.setInt(AppConstants.keyStreak, days);
  }
  
  int getStreak() {
    return _prefs.getInt(AppConstants.keyStreak) ?? 0;
  }
  
  // Last study date
  Future<void> setLastStudyDate(DateTime date) async {
    await _prefs.setString(AppConstants.keyLastStudyDate, date.toIso8601String());
  }
  
  DateTime? getLastStudyDate() {
    final dateStr = _prefs.getString(AppConstants.keyLastStudyDate);
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }
  
  // Theme mode
  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(AppConstants.keyThemeMode, mode);
  }
  
  String getThemeMode() {
    return _prefs.getString(AppConstants.keyThemeMode) ?? 'light';
  }
  
  // Onboarding completed
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(AppConstants.keyOnboardingCompleted, completed);
  }
  
  bool isOnboardingCompleted() {
    return _prefs.getBool(AppConstants.keyOnboardingCompleted) ?? false;
  }
  
  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}

