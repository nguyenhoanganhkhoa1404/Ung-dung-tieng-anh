import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../firebase_options.dart';

/// Tool để tạo sample data cho Dashboard
/// Chạy: flutter run -t lib/tools/setup_dashboard_data.dart -d edge

Future<void> main() async {
  print('\n🔥 SETTING UP DASHBOARD DATA...\n');

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    final firestore = FirebaseFirestore.instance;
    
    // User ID (khớp với code trong app)
    const userId = 'demo_user';
    
    print('👤 Creating user profile...');
    
    // 1. Tạo User Profile
    await firestore.collection('users').doc(userId).set({
      'user_id': userId,
      'name': 'Test User',
      'email': 'testuser@example.com',
      'total_xp': 250,
      'current_streak': 7,
      'total_learning_minutes': 180,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });

    // Mirror public leaderboard entry (không lưu email)
    await firestore.collection('leaderboard').doc(userId).set({
      'user_id': userId,
      'name': 'Test User',
      'total_xp': 250,
      'current_streak': 7,
      'total_learning_minutes': 180,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    
    print('✅ User profile created!\n');
    
    print('📚 Creating learning sessions...');
    
    // 2. Tạo Learning Sessions (7 ngày gần nhất)
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final sessionDate = now.subtract(Duration(days: i));
      final startTime = sessionDate.subtract(Duration(minutes: 20));
      final endTime = sessionDate;
      
      await firestore.collection('learning_sessions').add({
        'user_id': userId,
        'skill': i % 2 == 0 ? 'vocabulary' : 'grammar',
        'lesson_id': 'lesson_${i % 2 == 0 ? 'vocabulary' : 'grammar'}_${i + 1}',
        'start_time': Timestamp.fromDate(startTime),
        'end_time': Timestamp.fromDate(endTime),
        'duration_minutes': 20,
        'completed': true,
      });
      
      print('  ✅ Session ${i + 1}/7 created (${i % 2 == 0 ? 'Vocabulary' : 'Grammar'})');
    }
    
    print('✅ All sessions created!\n');
    
    print('📝 Creating exercise results...');
    
    // 3. Tạo Exercise Results cho 6 skills
    final skills = ['vocabulary', 'grammar', 'listening', 'speaking', 'reading', 'writing'];
    
    for (int i = 0; i < skills.length; i++) {
      final skill = skills[i];
      
      // Tạo 3 results cho mỗi skill
      for (int j = 0; j < 3; j++) {
        final correctAnswers = 7 + j; // 7, 8, 9
        const totalQuestions = 10;
        final accuracy = correctAnswers / totalQuestions;
        final xpEarned = (accuracy * 100).round();
        
        final resultDate = now.subtract(Duration(days: i * 3 + j));
        
        await firestore.collection('exercise_results').add({
          'user_id': userId,
          'skill': skill,
          'lesson_id': 'lesson_${skill}_${j + 1}',
          'correct_answers': correctAnswers,
          'total_questions': totalQuestions,
          'accuracy': accuracy,
          'xp_earned': xpEarned,
          'completed': true,
          'created_at': Timestamp.fromDate(resultDate),
        });
      }
      
      print('  ✅ Results for $skill created (3 exercises)');
    }
    
    print('✅ All exercise results created!\n');
    
    // 4. Summary
    print('═' * 60);
    print('🎉 DASHBOARD DATA SETUP COMPLETE!');
    print('═' * 60);
    print('');
    print('📊 Created:');
    print('  ✅ 1 User Profile (ID: $userId)');
    print('  ✅ 7 Learning Sessions (Vocabulary & Grammar)');
    print('  ✅ 18 Exercise Results (6 skills × 3 exercises)');
    print('');
    print('🔍 Verify in Firebase Console:');
    print('  → users collection: 1 document');
    print('  → learning_sessions collection: 7 documents');
    print('  → exercise_results collection: 18+ documents');
    print('');
    print('📱 Test in App:');
    print('  1. Mở app: flutter run -t lib/main_ui_demo.dart -d edge');
    print('  2. Navigate to Dashboard tab (icon bar chart)');
    print('  3. Dashboard sẽ hiển thị:');
    print('     • Total XP: 250');
    print('     • Current Streak: 7 days');
    print('     • Learning Minutes: 180 mins');
    print('     • Skill Progress: 6 skills');
    print('');
    print('⚠️  QUAN TRỌNG:');
    print('  Nếu Dashboard vẫn lỗi "requires an index",');
    print('  bạn cần tạo Firestore Indexes:');
    print('  → Xem: FIRESTORE_SETUP_GUIDE.md');
    print('');
    print('✅ Ready to test Dashboard!');
    print('');
    
  } catch (e) {
    print('❌ ERROR: $e');
    print('');
    print('Troubleshooting:');
    print('1. Check Firebase configuration');
    print('2. Check internet connection');
    print('3. Check Firestore permissions');
  }
}

