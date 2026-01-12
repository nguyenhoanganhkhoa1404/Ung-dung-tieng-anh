import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'presentation/app_new.dart';

/// Main entry point cho UI demo mới
/// 
/// Chạy bằng lệnh:
/// flutter run -t lib/main_ui_demo.dart -d edge
/// 
/// Tính năng:
/// ✅ Login/Signup với animations đẹp
/// ✅ Home với 6 skill cards (Vocabulary, Grammar, Listening, Speaking, Reading, Writing)
/// ✅ Dashboard với Analytics (XP, Streak, Learning Time)
/// ✅ Leaderboard với bảng xếp hạng realtime
/// ✅ Profile với stats và settings
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }
  
  runApp(const EnglishLearningApp());
}

