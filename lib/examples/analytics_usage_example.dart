import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../data/repositories/analytics_repository_impl.dart';
import '../domain/services/analytics_service.dart';
import '../domain/services/session_tracking_service.dart';
import '../domain/services/privacy_service.dart';
import '../domain/entities/learning_session_entity.dart';
import '../presentation/pages/dashboard/dashboard_page.dart';

/// EXAMPLE: Cách sử dụng hệ thống Analytics
/// 
/// ❌ KHÔNG FAKE DATA
/// ✅ Tất cả dữ liệu THỰC TẾ từ Firebase

class AnalyticsUsageExample {
  final String userId = 'user123'; // ID của user đang đăng nhập
  
  late final AnalyticsRepositoryImpl repository;
  late final AnalyticsService analyticsService;
  late final SessionTrackingService sessionTracking;
  late final PrivacyService privacyService;
  
  AnalyticsUsageExample() {
    // Khởi tạo services
    repository = AnalyticsRepositoryImpl();
    analyticsService = AnalyticsService(repository);
    sessionTracking = SessionTrackingService(repository);
    privacyService = PrivacyService(repository);
  }
  
  // ==========================================================================
  // SCENARIO 1: User bắt đầu học từ vựng
  // ==========================================================================
  
  Future<void> example1_StartVocabularyLesson() async {
    print('📚 User bắt đầu học từ vựng...');
    
    // Bắt đầu session
    await sessionTracking.startSession(
      userId: userId,
      skill: SkillType.vocabulary,
      lessonId: 'lesson_vocabulary_001',
    );
    
    print('✅ Session started!');
  }
  
  // ==========================================================================
  // SCENARIO 2: User làm bài tập và lưu kết quả THỰC TẾ
  // ==========================================================================
  
  Future<void> example2_CompleteExercise() async {
    print('📝 User làm bài tập...');
    
    // User trả lời: 8/10 câu đúng
    final correctAnswers = 8;
    final totalQuestions = 10;
    
    // Lưu kết quả THỰC TẾ
    await sessionTracking.saveExerciseResult(
      userId: userId,
      skill: SkillType.vocabulary,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      completed: true,
      lessonId: 'lesson_vocabulary_001',
    );
    
    print('✅ Exercise result saved!');
    print('📊 Accuracy: ${(correctAnswers / totalQuestions * 100).toStringAsFixed(1)}%');
  }
  
  // ==========================================================================
  // SCENARIO 3: User kết thúc session
  // ==========================================================================
  
  Future<void> example3_EndSession() async {
    print('🏁 User kết thúc session...');
    
    await sessionTracking.endSession();
    
    print('✅ Session ended!');
  }
  
  // ==========================================================================
  // SCENARIO 4: Hiển thị Dashboard với dữ liệu THỰC TẾ
  // ==========================================================================
  
  Widget example4_ShowDashboard() {
    return DashboardPage(
      userId: userId,
      analyticsService: analyticsService,
    );
  }
  
  // ==========================================================================
  // SCENARIO 5: Lấy thống kê tuần
  // ==========================================================================
  
  Future<void> example5_GetWeeklyReport() async {
    print('📈 Lấy báo cáo tuần...');
    
    final report = await analyticsService.getWeeklyReport(userId);
    
    print('✅ Báo cáo tuần (${report.startDate} - ${report.endDate}):');
    print('   • Thời gian học: ${report.totalHours.toStringAsFixed(1)} giờ');
    print('   • XP kiếm được: ${report.totalXp}');
    print('   • Số bài làm: ${report.totalExercises}');
    print('   • Độ chính xác TB: ${report.averageAccuracyPercent}%');
  }
  
  // ==========================================================================
  // SCENARIO 6: AI phát hiện kỹ năng yếu
  // ==========================================================================
  
  Future<void> example6_DetectWeakSkills() async {
    print('🤖 AI phân tích kỹ năng yếu...');
    
    final weaknesses = await analyticsService.detectWeakSkills(userId);
    
    if (weaknesses.isEmpty) {
      print('✅ Không có kỹ năng yếu!');
    } else {
      print('⚠️ Kỹ năng cần cải thiện:');
      for (var weakness in weaknesses) {
        print('   • ${weakness.skill.displayName}: ${weakness.accuracyPercent}%');
        print('     → ${weakness.recommendedPractice}');
      }
    }
  }
  
  // ==========================================================================
  // SCENARIO 7: Export dữ liệu (GDPR)
  // ==========================================================================
  
  Future<void> example7_ExportData() async {
    print('📦 Export dữ liệu người dùng...');
    
    final file = await privacyService.exportUserData(userId);
    
    print('✅ Dữ liệu đã được export tại: ${file.path}');
  }
  
  // ==========================================================================
  // SCENARIO 8: Refresh streak hàng ngày
  // ==========================================================================
  
  Future<void> example8_RefreshStreak() async {
    print('🔥 Refresh streak...');
    
    await analyticsService.refreshStreak(userId);
    
    final profile = await repository.getUserProfile(userId);
    
    print('✅ Current streak: ${profile?.currentStreak ?? 0} ngày');
  }
  
  // ==========================================================================
  // COMPLETE WORKFLOW: User học 1 bài hoàn chỉnh
  // ==========================================================================
  
  Future<void> exampleComplete_FullLearningFlow() async {
    print('🎓 ========== BẮT ĐẦU HỌC BÀI ==========');
    
    // 1. Bắt đầu session
    await sessionTracking.startSession(
      userId: userId,
      skill: SkillType.listening,
      lessonId: 'lesson_listening_001',
    );
    print('✅ Session bắt đầu');
    
    // 2. User học... (giả sử 15 phút)
    await Future.delayed(const Duration(seconds: 2)); // Simulate learning
    
    // 3. User làm bài tập 1: 7/10
    await sessionTracking.saveExerciseResult(
      userId: userId,
      skill: SkillType.listening,
      correctAnswers: 7,
      totalQuestions: 10,
      completed: true,
      lessonId: 'lesson_listening_001',
    );
    print('✅ Bài tập 1: 7/10 (70%)');
    
    // 4. User làm bài tập 2: 9/10
    await sessionTracking.saveExerciseResult(
      userId: userId,
      skill: SkillType.listening,
      correctAnswers: 9,
      totalQuestions: 10,
      completed: true,
      lessonId: 'lesson_listening_001',
    );
    print('✅ Bài tập 2: 9/10 (90%)');
    
    // 5. Kết thúc session
    await sessionTracking.endSession();
    print('✅ Session kết thúc');
    
    // 6. Refresh streak
    await analyticsService.refreshStreak(userId);
    
    // 7. Lấy dashboard data mới
    final dashboard = await analyticsService.getDashboardData(userId);
    
    print('\n📊 ========== THỐNG KÊ SAU KHI HỌC ==========');
    print('   • Total XP: ${dashboard.totalXp}');
    print('   • Streak: ${dashboard.currentStreak} ngày');
    print('   • Học tập: ${dashboard.totalLearningHours.toStringAsFixed(1)} giờ');
    
    print('\n📈 Tiến độ kỹ năng:');
    dashboard.skillProgress.forEach((skill, progress) {
      print('   • ${skill.displayName}: ${(progress * 100).round()}%');
    });
  }
}

/// Widget example để test toàn bộ flow
class AnalyticsExampleApp extends StatelessWidget {
  const AnalyticsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final example = AnalyticsUsageExample();
    
    return MaterialApp(
      title: 'Analytics Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Analytics System Example'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ElevatedButton(
              onPressed: () => example.example1_StartVocabularyLesson(),
              child: const Text('1. Start Lesson'),
            ),
            ElevatedButton(
              onPressed: () => example.example2_CompleteExercise(),
              child: const Text('2. Complete Exercise'),
            ),
            ElevatedButton(
              onPressed: () => example.example3_EndSession(),
              child: const Text('3. End Session'),
            ),
            ElevatedButton(
              onPressed: () => example.example5_GetWeeklyReport(),
              child: const Text('5. Weekly Report'),
            ),
            ElevatedButton(
              onPressed: () => example.example6_DetectWeakSkills(),
              child: const Text('6. Detect Weak Skills (AI)'),
            ),
            ElevatedButton(
              onPressed: () => example.example7_ExportData(),
              child: const Text('7. Export Data (GDPR)'),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () => example.exampleComplete_FullLearningFlow(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('🎓 FULL LEARNING FLOW'),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => example.example4_ShowDashboard(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('📊 Show Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

// Main function để chạy app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase already initialized or error: $e');
  }
  
  runApp(const AnalyticsExampleApp());
}

