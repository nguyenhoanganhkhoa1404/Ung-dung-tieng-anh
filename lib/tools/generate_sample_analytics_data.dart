import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';
import '../firebase_options.dart';

/// Tool để generate dữ liệu Analytics THỰC vào Firebase
/// Chạy: flutter run -t lib/tools/generate_sample_analytics_data.dart -d edge
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GenerateSampleDataApp());
}

class GenerateSampleDataApp extends StatelessWidget {
  const GenerateSampleDataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generate Sample Analytics Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GenerateSampleDataPage(),
    );
  }
}

class GenerateSampleDataPage extends StatefulWidget {
  const GenerateSampleDataPage({super.key});

  @override
  State<GenerateSampleDataPage> createState() => _GenerateSampleDataPageState();
}

class _GenerateSampleDataPageState extends State<GenerateSampleDataPage> {
  final _firestore = FirebaseFirestore.instance;
  final _random = Random();
  bool _isGenerating = false;
  final List<String> _logs = [];
  Map<String, int>? _summary;

  final List<String> _skills = [
    'vocabulary',
    'grammar',
    'listening',
    'speaking',
    'reading',
    'writing',
  ];

  void _log(String message) {
    setState(() {
      _logs.add('[${DateTime.now().toString().substring(11, 19)}] $message');
    });
    print(message);
  }

  Future<void> _generateData() async {
    setState(() {
      _isGenerating = true;
      _logs.clear();
      _summary = null;
    });

    try {
      _log('🚀 Bắt đầu generate dữ liệu THỰC...\n');

      // 1. Tạo test user
      final userId = 'test_user_${DateTime.now().millisecondsSinceEpoch}';
      _log('👤 Tạo user: $userId');

      await _firestore.collection('users').doc(userId).set({
        'name': 'Test User',
        'email': 'test@example.com',
        'created_at': FieldValue.serverTimestamp(),
        'last_active': FieldValue.serverTimestamp(),
        'total_xp': 0, // Bắt đầu từ 0
        'current_streak': 0, // Bắt đầu từ 0
        'total_learning_minutes': 0, // Bắt đầu từ 0
        'avatar_url': '',
        'current_level': 'A1',
      });
      _log('✅ User created\n');

      // 2. Generate learning sessions (30 ngày gần nhất)
      _log('📚 Generating learning sessions...');
      int sessionCount = 0;
      int totalMinutes = 0;

      for (int day = 0; day < 30; day++) {
        // Random học 0-3 lần/ngày
        final sessionsPerDay = _random.nextInt(4);

        for (int i = 0; i < sessionsPerDay; i++) {
          final skill = _skills[_random.nextInt(_skills.length)];
          final startTime = DateTime.now()
              .subtract(Duration(days: day))
              .add(Duration(hours: _random.nextInt(12) + 8));
          final duration = _random.nextInt(40) + 10; // 10-50 phút

          await _firestore.collection('learning_sessions').add({
            'user_id': userId,
            'skill': skill,
            'lesson_id': 'lesson_${skill}_${_random.nextInt(100)}',
            'start_time': Timestamp.fromDate(startTime),
            'end_time': Timestamp.fromDate(startTime.add(Duration(minutes: duration))),
            'duration_minutes': duration,
            'completed': true,
          });

          sessionCount++;
          totalMinutes += duration;
        }
      }
      _log('✅ Created $sessionCount sessions ($totalMinutes minutes)\n');

      // 3. Generate exercise results
      _log('✅ Generating exercise results...');
      int resultCount = 0;
      int totalXp = 0;
      final skillAccuracy = <String, List<double>>{};

      for (final skill in _skills) {
        skillAccuracy[skill] = [];
        // Mỗi skill làm 5-15 bài
        final exercisesCount = _random.nextInt(11) + 5;

        for (int i = 0; i < exercisesCount; i++) {
          final totalQuestions = 10;
          // Random accuracy: 30-100%
          final correctAnswers = _random.nextInt(8) + 3; // 3-10 đúng
          final accuracy = correctAnswers / totalQuestions;

          // Tính XP (giống công thức thực)
          int xp = correctAnswers * 5; // 5 XP/câu đúng
          xp += 10; // Hoàn thành
          if (correctAnswers == totalQuestions) {
            xp += 20; // Perfect
          }
          if (skill == 'speaking') {
            xp += 30; // Speaking bonus
          }

          final createdAt = DateTime.now()
              .subtract(Duration(days: _random.nextInt(30)));

          await _firestore.collection('exercise_results').add({
            'user_id': userId,
            'skill': skill,
            'correct_answers': correctAnswers,
            'total_questions': totalQuestions,
            'accuracy': accuracy,
            'xp_earned': xp,
            'created_at': Timestamp.fromDate(createdAt),
            'lesson_id': 'lesson_${skill}_${_random.nextInt(100)}',
          });

          resultCount++;
          totalXp += xp;
          skillAccuracy[skill]!.add(accuracy);
        }
      }
      _log('✅ Created $resultCount exercises (Total XP: $totalXp)\n');

      // 4. Tính streak
      _log('🔥 Calculating streak...');
      final studyDays = <DateTime>{};
      for (int day = 0; day < 30; day++) {
        if (_random.nextDouble() > 0.3) {
          // 70% chance học mỗi ngày
          studyDays.add(
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ).subtract(Duration(days: day)),
          );
        }
      }

      // Tính streak từ hôm nay
      int streak = 0;
      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      for (int i = 0; i < 30; i++) {
        final date = today.subtract(Duration(days: i));
        if (studyDays.contains(date)) {
          streak++;
        } else if (i > 0) {
          // Nếu không phải hôm nay và không học → break
          break;
        }
      }
      _log('✅ Streak: $streak days\n');

      // 5. Update user với dữ liệu tính toán
      _log('📊 Updating user stats...');
      await _firestore.collection('users').doc(userId).update({
        'total_xp': totalXp,
        'current_streak': streak,
        'total_learning_minutes': totalMinutes,
        'last_active': FieldValue.serverTimestamp(),
      });
      _log('✅ User stats updated\n');

      // 6. Tính skill progress
      _log('📈 Skill Progress:');
      for (final entry in skillAccuracy.entries) {
        if (entry.value.isNotEmpty) {
          final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
          _log('   • ${entry.key}: ${(avg * 100).toStringAsFixed(1)}%');
        }
      }

      setState(() {
        _summary = {
          'user_id_length': userId.length,
          'sessions': sessionCount,
          'minutes': totalMinutes,
          'exercises': resultCount,
          'total_xp': totalXp,
          'streak': streak,
        };
      });

      _log('\n🎉 HOÀN THÀNH! Dữ liệu đã được add vào Firebase!');
      _log('User ID: $userId');

      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Thành công!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Dữ liệu đã được tạo và lưu vào Firebase:'),
                const SizedBox(height: 12),
                Text('• User ID: $userId'),
                Text('• Sessions: $sessionCount'),
                Text('• Exercises: $resultCount'),
                Text('• Total XP: $totalXp'),
                Text('• Streak: $streak days'),
                Text('• Total Minutes: $totalMinutes'),
                const SizedBox(height: 12),
                const Text(
                  'Bây giờ bạn có thể verify data để kiểm tra!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _log('\n❌ ERROR: $e');
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎲 Generate Sample Analytics Data'),
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
                  '📊 Generate Real Analytics Data',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tạo dữ liệu học tập THỰC và lưu vào Firebase',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          // Generate Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generateData,
                icon: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow),
                label: Text(
                  _isGenerating ? 'Generating...' : 'Generate Data',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ),

          // Summary
          if (_summary != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.analytics, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('Sessions: ${_summary!['sessions']}'),
                      Text('Exercises: ${_summary!['exercises']}'),
                      Text('Total XP: ${_summary!['total_xp']}'),
                      Text('Streak: ${_summary!['streak']} days'),
                      Text('Minutes: ${_summary!['minutes']}'),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 16),

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
                        'Press "Generate Data" to start',
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
                  'Tool này sẽ tạo:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• 1 test user (XP, Streak, Minutes = 0 ban đầu)\n'
                  '• 20-90 learning sessions (30 ngày)\n'
                  '• 30-90 exercise results với accuracy thật\n'
                  '• Tính toán XP, Streak, Progress THỰC TẾ\n'
                  '• Lưu tất cả vào Firebase Firestore',
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

