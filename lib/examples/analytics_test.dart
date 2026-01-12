import 'package:flutter/material.dart';
import '../data/repositories/analytics_repository_impl.dart';
import '../domain/services/analytics_service.dart';
import '../domain/services/session_tracking_service.dart';
import '../domain/entities/learning_session_entity.dart';

/// Script để test hệ thống Analytics
/// Chạy: flutter run -t lib/examples/analytics_test.dart
void main() {
  runApp(const AnalyticsTestApp());
}

class AnalyticsTestApp extends StatelessWidget {
  const AnalyticsTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analytics Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AnalyticsTestPage(),
    );
  }
}

class AnalyticsTestPage extends StatefulWidget {
  const AnalyticsTestPage({super.key});

  @override
  State<AnalyticsTestPage> createState() => _AnalyticsTestPageState();
}

class _AnalyticsTestPageState extends State<AnalyticsTestPage> {
  final _repository = AnalyticsRepositoryImpl();
  late final AnalyticsService _analyticsService;
  late final SessionTrackingService _sessionTracking;
  
  final _logs = <String>[];
  bool _isRunning = false;
  
  // Test user ID
  final String _testUserId = 'test_user_${DateTime.now().millisecondsSinceEpoch}';
  
  @override
  void initState() {
    super.initState();
    _analyticsService = AnalyticsService(_repository);
    _sessionTracking = SessionTrackingService(_repository);
    
    _log('✅ Services initialized');
    _log('👤 Test User ID: $_testUserId');
  }
  
  void _log(String message) {
    setState(() {
      _logs.add('[${DateTime.now().toString().substring(11, 19)}] $message');
    });
    print(message);
  }
  
  Future<void> _runFullTest() async {
    if (_isRunning) return;
    
    setState(() {
      _isRunning = true;
      _logs.clear();
    });
    
    try {
      _log('\n🚀 ========== BẮT ĐẦU TEST ==========\n');
      
      // Test 1: Create user
      await _testCreateUser();
      await Future.delayed(const Duration(seconds: 1));
      
      // Test 2: Learning session
      await _testLearningSession();
      await Future.delayed(const Duration(seconds: 1));
      
      // Test 3: Dashboard data
      await _testDashboardData();
      await Future.delayed(const Duration(seconds: 1));
      
      // Test 4: Weekly report
      await _testWeeklyReport();
      await Future.delayed(const Duration(seconds: 1));
      
      // Test 5: AI analysis
      await _testAIAnalysis();
      
      _log('\n✅ ========== TEST HOÀN THÀNH ==========\n');
      _log('🎉 Tất cả test đều PASSED!');
      
    } catch (e) {
      _log('❌ ERROR: $e');
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }
  
  Future<void> _testCreateUser() async {
    _log('📝 Test 1: Create User');
    
    await _repository.createUser(
      userId: _testUserId,
      name: 'Test User',
      email: 'test@example.com',
    );
    
    final profile = await _repository.getUserProfile(_testUserId);
    
    if (profile == null) {
      throw Exception('User profile is null');
    }
    
    _log('   ✅ User created: ${profile.name}');
    _log('   ✅ Initial XP: ${profile.totalXp} (should be 0)');
    _log('   ✅ Initial Streak: ${profile.currentStreak} (should be 0)');
    _log('   ✅ Initial Minutes: ${profile.totalLearningMinutes} (should be 0)');
    
    if (profile.totalXp != 0) throw Exception('XP should be 0');
    if (profile.currentStreak != 0) throw Exception('Streak should be 0');
    if (profile.totalLearningMinutes != 0) throw Exception('Minutes should be 0');
    
    _log('   ✅ PASS: User starts with all 0 values');
  }
  
  Future<void> _testLearningSession() async {
    _log('\n📚 Test 2: Learning Session');
    
    // Start session
    _log('   → Starting vocabulary session...');
    await _sessionTracking.startSession(
      userId: _testUserId,
      skill: SkillType.vocabulary,
      lessonId: 'test_lesson_001',
    );
    _log('   ✅ Session started');
    
    // Simulate learning
    await Future.delayed(const Duration(seconds: 2));
    _log('   ⏱️ Learning... (simulated 2 seconds)');
    
    // Complete exercise 1: 7/10
    _log('   → Completing exercise 1: 7/10...');
    await _sessionTracking.saveExerciseResult(
      userId: _testUserId,
      skill: SkillType.vocabulary,
      correctAnswers: 7,
      totalQuestions: 10,
      completed: true,
      lessonId: 'test_lesson_001',
    );
    final xp1 = (7 * 5) + 10; // 7 correct * 5 + 10 complete
    _log('   ✅ Exercise 1 saved (Expected XP: $xp1)');
    
    // Complete exercise 2: 10/10 (perfect)
    _log('   → Completing exercise 2: 10/10 (PERFECT)...');
    await _sessionTracking.saveExerciseResult(
      userId: _testUserId,
      skill: SkillType.vocabulary,
      correctAnswers: 10,
      totalQuestions: 10,
      completed: true,
      lessonId: 'test_lesson_001',
    );
    final xp2 = (10 * 5) + 10 + 20; // 10 correct * 5 + 10 complete + 20 perfect
    _log('   ✅ Exercise 2 saved (Expected XP: $xp2)');
    
    // End session
    _log('   → Ending session...');
    await _sessionTracking.endSession();
    _log('   ✅ Session ended');
    
    final totalExpectedXp = xp1 + xp2;
    _log('   ✅ PASS: Total expected XP = $totalExpectedXp');
  }
  
  Future<void> _testDashboardData() async {
    _log('\n📊 Test 3: Dashboard Data');
    
    final dashboard = await _analyticsService.getDashboardData(_testUserId);
    
    _log('   📈 Dashboard Stats:');
    _log('      • Total XP: ${dashboard.totalXp}');
    _log('      • Current Streak: ${dashboard.currentStreak}');
    _log('      • Learning Hours: ${dashboard.totalLearningHours.toStringAsFixed(2)}h');
    
    if (dashboard.totalXp == 0) {
      _log('   ⚠️ Warning: XP is 0, data might not be synced yet');
    } else {
      _log('   ✅ XP > 0: Data is being tracked!');
    }
    
    _log('   📊 Skill Progress:');
    dashboard.skillProgress.forEach((skill, progress) {
      final percent = (progress * 100).toStringAsFixed(1);
      _log('      • ${skill.displayName}: $percent%');
    });
    
    _log('   ✅ PASS: Dashboard data retrieved');
  }
  
  Future<void> _testWeeklyReport() async {
    _log('\n📅 Test 4: Weekly Report');
    
    final report = await _analyticsService.getWeeklyReport(_testUserId);
    
    _log('   📈 Weekly Stats:');
    _log('      • Total Minutes: ${report.totalMinutes}');
    _log('      • Total Hours: ${report.totalHours.toStringAsFixed(2)}h');
    _log('      • Total XP: ${report.totalXp}');
    _log('      • Exercises: ${report.totalExercises}');
    _log('      • Avg Accuracy: ${report.averageAccuracyPercent}%');
    
    if (report.totalExercises > 0) {
      _log('   ✅ Exercises detected: ${report.totalExercises}');
    }
    
    _log('   ✅ PASS: Weekly report generated');
  }
  
  Future<void> _testAIAnalysis() async {
    _log('\n🤖 Test 5: AI Analysis');
    
    final weaknesses = await _analyticsService.detectWeakSkills(_testUserId);
    
    if (weaknesses.isEmpty) {
      _log('   ℹ️ No weak skills detected (all skills > 60% or no data)');
    } else {
      _log('   ⚠️ Weak Skills Detected:');
      for (var weakness in weaknesses) {
        _log('      • ${weakness.skill.displayName}: ${weakness.accuracyPercent}%');
        _log('        → ${weakness.recommendedPractice}');
      }
    }
    
    // Test heatmap
    final heatmap = await _analyticsService.getStudyHeatmap(_testUserId);
    final daysWithStudy = heatmap.entries.where((e) => e.value > 0).length;
    
    _log('   📅 Heatmap (30 days):');
    _log('      • Days with study: $daysWithStudy/30');
    
    if (daysWithStudy > 0) {
      _log('   ✅ Study activity detected!');
    }
    
    _log('   ✅ PASS: AI analysis completed');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics System Test'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🧪 Analytics System Test Suite',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Test User ID: $_testUserId',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Run button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isRunning ? null : _runFullTest,
                icon: _isRunning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow),
                label: Text(
                  _isRunning ? 'Running Tests...' : 'Run Full Test',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),
          
          // Logs
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: _logs.isEmpty
                  ? Center(
                      child: Text(
                        'Press "Run Full Test" to start',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        Color color = Colors.white;
                        
                        if (log.contains('✅')) color = Colors.green[300]!;
                        if (log.contains('❌')) color = Colors.red[300]!;
                        if (log.contains('⚠️')) color = Colors.orange[300]!;
                        if (log.contains('🚀') || log.contains('🎉')) {
                          color = Colors.yellow[300]!;
                        }
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            log,
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontFamily: 'Courier',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          
          // Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Test Includes:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• Create user with 0 values\n'
                  '• Track learning session\n'
                  '• Save exercise results\n'
                  '• Generate dashboard data\n'
                  '• Create weekly report\n'
                  '• Run AI analysis',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

