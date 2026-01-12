import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';

class HiveDatabase {
  static Box? _vocabularyBox;
  static Box? _lessonsBox;
  static Box? _progressBox;
  static Box? _settingsBox;
  
  static Future<void> init() async {
    await Hive.initFlutter();
    
    _vocabularyBox = await Hive.openBox(AppConstants.vocabularyBox);
    _lessonsBox = await Hive.openBox(AppConstants.lessonsBox);
    _progressBox = await Hive.openBox(AppConstants.progressBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
  }
  
  // Vocabulary operations
  Future<void> saveVocabulary(String key, Map<String, dynamic> data) async {
    await _vocabularyBox?.put(key, data);
  }
  
  Map<String, dynamic>? getVocabulary(String key) {
    return _vocabularyBox?.get(key);
  }
  
  Future<void> deleteVocabulary(String key) async {
    await _vocabularyBox?.delete(key);
  }
  
  List<Map<String, dynamic>> getAllVocabulary() {
    final List<Map<String, dynamic>> result = [];
    for (var key in _vocabularyBox?.keys ?? []) {
      final data = _vocabularyBox?.get(key);
      if (data != null) {
        result.add(Map<String, dynamic>.from(data));
      }
    }
    return result;
  }
  
  // Lessons operations
  Future<void> saveLesson(String key, Map<String, dynamic> data) async {
    await _lessonsBox?.put(key, data);
  }
  
  Map<String, dynamic>? getLesson(String key) {
    return _lessonsBox?.get(key);
  }
  
  // Progress operations
  Future<void> saveProgress(String key, Map<String, dynamic> data) async {
    await _progressBox?.put(key, data);
  }
  
  Map<String, dynamic>? getProgress(String key) {
    return _progressBox?.get(key);
  }
  
  // Settings operations
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox?.put(key, value);
  }
  
  T? getSetting<T>(String key) {
    return _settingsBox?.get(key);
  }
  
  // Clear operations
  Future<void> clearAll() async {
    await _vocabularyBox?.clear();
    await _lessonsBox?.clear();
    await _progressBox?.clear();
  }
}

