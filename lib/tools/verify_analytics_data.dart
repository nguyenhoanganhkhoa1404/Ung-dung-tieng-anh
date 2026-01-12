import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

/// Tool để kiểm tra dữ liệu Analytics THỰC TẾ trong Firebase
/// Chạy: flutter run -t lib/tools/verify_analytics_data.dart -d edge
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const VerifyAnalyticsDataApp());
}

class VerifyAnalyticsDataApp extends StatelessWidget {
  const VerifyAnalyticsDataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verify Analytics Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const VerifyAnalyticsPage(),
    );
  }
}

class VerifyAnalyticsPage extends StatefulWidget {
  const VerifyAnalyticsPage({super.key});

  @override
  State<VerifyAnalyticsPage> createState() => _VerifyAnalyticsPageState();
}

class _VerifyAnalyticsPageState extends State<VerifyAnalyticsPage> {
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  Map<String, dynamic>? _verificationResult;
  String? _error;

  Future<void> _verifyData() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _verificationResult = null;
    });

    try {
      final result = <String, dynamic>{};

      // 1. Kiểm tra users collection
      final usersSnapshot = await _firestore.collection('users').get();
      result['users_count'] = usersSnapshot.docs.length;
      result['users_exist'] = usersSnapshot.docs.isNotEmpty;

      if (usersSnapshot.docs.isNotEmpty) {
        // Lấy user đầu tiên để check data
        final firstUser = usersSnapshot.docs.first.data();
        result['sample_user'] = {
          'id': usersSnapshot.docs.first.id,
          'total_xp': firstUser['total_xp'] ?? 0,
          'current_streak': firstUser['current_streak'] ?? 0,
          'total_learning_minutes': firstUser['total_learning_minutes'] ?? 0,
        };
      }

      // 2. Kiểm tra learning_sessions collection
      final sessionsSnapshot = await _firestore.collection('learning_sessions').get();
      result['sessions_count'] = sessionsSnapshot.docs.length;
      result['sessions_exist'] = sessionsSnapshot.docs.isNotEmpty;

      if (sessionsSnapshot.docs.isNotEmpty) {
        final firstSession = sessionsSnapshot.docs.first.data();
        result['sample_session'] = {
          'id': sessionsSnapshot.docs.first.id,
          'skill': firstSession['skill'] ?? '',
          'duration_minutes': firstSession['duration_minutes'] ?? 0,
          'completed': firstSession['completed'] ?? false,
        };
      }

      // 3. Kiểm tra exercise_results collection
      final resultsSnapshot = await _firestore.collection('exercise_results').get();
      result['results_count'] = resultsSnapshot.docs.length;
      result['results_exist'] = resultsSnapshot.docs.isNotEmpty;

      if (resultsSnapshot.docs.isNotEmpty) {
        final firstResult = resultsSnapshot.docs.first.data();
        result['sample_result'] = {
          'id': resultsSnapshot.docs.first.id,
          'skill': firstResult['skill'] ?? '',
          'correct_answers': firstResult['correct_answers'] ?? 0,
          'total_questions': firstResult['total_questions'] ?? 0,
          'accuracy': firstResult['accuracy'] ?? 0.0,
          'xp_earned': firstResult['xp_earned'] ?? 0,
        };
      }

      // 4. Tính toán tổng XP từ exercise_results (REAL DATA)
      if (resultsSnapshot.docs.isNotEmpty) {
        int totalXp = 0;
        for (var doc in resultsSnapshot.docs) {
          totalXp += (doc.data()['xp_earned'] as int?) ?? 0;
        }
        result['calculated_total_xp'] = totalXp;
      }

      // 5. Kiểm tra vocabulary collection
      final vocabSnapshot = await _firestore.collection('vocabulary').get();
      result['vocabulary_count'] = vocabSnapshot.docs.length;
      result['vocabulary_exist'] = vocabSnapshot.docs.isNotEmpty;

      setState(() {
        _verificationResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Verify Analytics Data'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📊 Analytics Data Verification',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kiểm tra xem dữ liệu trong Firebase có THỰC hay FAKE',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Verify Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _verifyData,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(
                _isLoading ? 'Đang kiểm tra...' : 'Verify Data',
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 24),

            // Results
            Expanded(
              child: _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
          ],
        ),
      );
    }

    if (_verificationResult == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nhấn "Verify Data" để kiểm tra',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        _buildSection(
          '👥 USERS',
          _verificationResult!['users_exist'] as bool,
          _verificationResult!['users_count'] as int,
          _verificationResult!['sample_user'] as Map<String, dynamic>?,
        ),
        const SizedBox(height: 16),
        _buildSection(
          '📚 LEARNING SESSIONS',
          _verificationResult!['sessions_exist'] as bool,
          _verificationResult!['sessions_count'] as int,
          _verificationResult!['sample_session'] as Map<String, dynamic>?,
        ),
        const SizedBox(height: 16),
        _buildSection(
          '✅ EXERCISE RESULTS',
          _verificationResult!['results_exist'] as bool,
          _verificationResult!['results_count'] as int,
          _verificationResult!['sample_result'] as Map<String, dynamic>?,
        ),
        const SizedBox(height: 16),
        _buildVocabularySection(),
        const SizedBox(height: 16),
        _buildSummary(),
      ],
    );
  }

  Widget _buildSection(
    String title,
    bool exists,
    int count,
    Map<String, dynamic>? sample,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  exists ? Icons.check_circle : Icons.cancel,
                  color: exists ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Số lượng: $count documents'),
            if (sample != null) ...[
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Sample Data:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              ...sample.entries.map((e) => Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Text('• ${e.key}: ${e.value}'),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVocabularySection() {
    final vocabCount = _verificationResult!['vocabulary_count'] as int;
    final vocabExists = _verificationResult!['vocabulary_exist'] as bool;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  vocabExists ? Icons.check_circle : Icons.cancel,
                  color: vocabExists ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                const Text(
                  '📖 VOCABULARY',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Số lượng: $vocabCount từ vựng'),
            if (vocabCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '✅ Đã import từ vựng vào database',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final usersExist = _verificationResult!['users_exist'] as bool;
    final sessionsExist = _verificationResult!['sessions_exist'] as bool;
    final resultsExist = _verificationResult!['results_exist'] as bool;
    final totalXp = _verificationResult!['calculated_total_xp'] as int?;

    final hasRealData = usersExist || sessionsExist || resultsExist;

    return Card(
      color: hasRealData ? Colors.green[50] : Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasRealData ? Icons.verified : Icons.warning,
                  color: hasRealData ? Colors.green : Colors.orange,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  hasRealData ? '✅ CÓ DỮ LIỆU THẬT!' : '⚠️ CHƯA CÓ DỮ LIỆU',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (hasRealData) ...[
              Text(
                'Dữ liệu Analytics đã có trong database:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              if (usersExist)
                const Text('  ✓ Users profile có data'),
              if (sessionsExist)
                const Text('  ✓ Learning sessions có data'),
              if (resultsExist)
                const Text('  ✓ Exercise results có data'),
              if (totalXp != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        'Tổng XP tính từ database: $totalXp',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ] else ...[
              const Text(
                'Dashboard hiện tại có thể đang hiển thị:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text('  • Dữ liệu mặc định (fake)'),
              const Text('  • Hoặc dữ liệu từ local storage'),
              const SizedBox(height: 12),
              const Text(
                'Để có dữ liệu thật, bạn cần:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const Text('  1. Tạo user account'),
              const Text('  2. Học bài và làm bài tập'),
              const Text('  3. System sẽ tự động track'),
            ],
          ],
        ),
      ),
    );
  }
}

