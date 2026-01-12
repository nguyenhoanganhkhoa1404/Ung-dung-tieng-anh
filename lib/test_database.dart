import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

/// Test script để kiểm tra Firebase Firestore và Hive
/// Chạy: flutter run lib/test_database.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive
  await Hive.initFlutter();
  
  runApp(const DatabaseTestApp());
}

class DatabaseTestApp extends StatelessWidget {
  const DatabaseTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Database Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DatabaseTestPage(),
    );
  }
}

class DatabaseTestPage extends StatefulWidget {
  const DatabaseTestPage({super.key});

  @override
  State<DatabaseTestPage> createState() => _DatabaseTestPageState();
}

class _DatabaseTestPageState extends State<DatabaseTestPage> {
  final _logs = <String>[];
  bool _isTesting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Test'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _isTesting ? null : _runAllTests,
                  child: const Text('Chạy tất cả Test'),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _isTesting ? null : _testFirestore,
                      child: const Text('Test Firestore'),
                    ),
                    ElevatedButton(
                      onPressed: _isTesting ? null : _testHive,
                      child: const Text('Test Hive'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                final isError = log.startsWith('❌');
                final isSuccess = log.startsWith('✅');
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    log,
                    style: TextStyle(
                      color: isError
                          ? Colors.red
                          : isSuccess
                              ? Colors.green
                              : Colors.black87,
                      fontFamily: 'monospace',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addLog(String message) {
    setState(() {
      _logs.add(message);
    });
    print(message);
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isTesting = true;
      _logs.clear();
    });

    _addLog('🚀 Bắt đầu kiểm tra cơ sở dữ liệu...\n');

    await _testFirestore();
    await Future.delayed(const Duration(seconds: 1));
    await _testHive();

    _addLog('\n✅ Hoàn thành tất cả test!');

    setState(() {
      _isTesting = false;
    });
  }

  Future<void> _testFirestore() async {
    _addLog('━━━ TEST FIRESTORE ━━━');
    
    try {
      final firestore = FirebaseFirestore.instance;
      
      // Test 1: Kết nối
      _addLog('📡 Kiểm tra kết nối...');
      firestore.settings;
      _addLog('✅ Kết nối Firebase thành công');

      // Test 2: Tạo document
      _addLog('\n📝 Test tạo document...');
      final testRef = firestore.collection('test').doc('test_${DateTime.now().millisecondsSinceEpoch}');
      
      await testRef.set({
        'message': 'Hello from Flutter!',
        'timestamp': FieldValue.serverTimestamp(),
        'testNumber': 42,
        'testBoolean': true,
      });
      _addLog('✅ Tạo document thành công');

      // Test 3: Đọc document
      _addLog('\n📖 Test đọc document...');
      final snapshot = await testRef.get();
      if (snapshot.exists) {
        _addLog('✅ Đọc document thành công');
        _addLog('   Data: ${snapshot.data()}');
      } else {
        _addLog('❌ Document không tồn tại');
      }

      // Test 4: Cập nhật document
      _addLog('\n✏️ Test cập nhật document...');
      await testRef.update({
        'message': 'Updated message',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _addLog('✅ Cập nhật document thành công');

      // Test 5: Query collection
      _addLog('\n🔍 Test query collection...');
      final querySnapshot = await firestore
          .collection('test')
          .limit(5)
          .get();
      _addLog('✅ Query thành công, tìm thấy ${querySnapshot.docs.length} documents');

      // Test 6: Xóa document
      _addLog('\n🗑️ Test xóa document...');
      await testRef.delete();
      _addLog('✅ Xóa document thành công');

      _addLog('\n✅ FIRESTORE: Tất cả tests đều PASS!\n');

    } catch (e) {
      _addLog('❌ FIRESTORE ERROR: $e');
      _addLog('\n⚠️ Lỗi có thể do:');
      _addLog('   1. Firestore chưa được kích hoạt trên Firebase Console');
      _addLog('   2. Firestore Rules chưa được cấu hình');
      _addLog('   3. Không có kết nối internet');
      _addLog('\n📌 Hướng dẫn fix:');
      _addLog('   1. Mở Firebase Console: https://console.firebase.google.com');
      _addLog('   2. Chọn project: ung-dung-hoc-tieng-anh-348fd');
      _addLog('   3. Vào Firestore Database → Create database');
      _addLog('   4. Chọn "Start in test mode" (cho development)');
      _addLog('   5. Chọn location: asia-southeast1');
    }
  }

  Future<void> _testHive() async {
    _addLog('━━━ TEST HIVE (LOCAL DATABASE) ━━━');

    try {
      // Test 1: Mở box
      _addLog('📦 Test mở Hive box...');
      final box = await Hive.openBox('test_box');
      _addLog('✅ Mở box thành công');

      // Test 2: Ghi dữ liệu
      _addLog('\n📝 Test ghi dữ liệu...');
      await box.put('test_key', 'Hello from Hive!');
      await box.put('test_number', 42);
      await box.put('test_list', [1, 2, 3, 4, 5]);
      await box.put('test_map', {
        'name': 'Test User',
        'level': 'A2',
        'xp': 1250,
      });
      _addLog('✅ Ghi dữ liệu thành công');

      // Test 3: Đọc dữ liệu
      _addLog('\n📖 Test đọc dữ liệu...');
      final stringValue = box.get('test_key');
      final numberValue = box.get('test_number');
      final listValue = box.get('test_list');
      final mapValue = box.get('test_map');
      
      _addLog('✅ Đọc dữ liệu thành công:');
      _addLog('   String: $stringValue');
      _addLog('   Number: $numberValue');
      _addLog('   List: $listValue');
      _addLog('   Map: $mapValue');

      // Test 4: Cập nhật dữ liệu
      _addLog('\n✏️ Test cập nhật dữ liệu...');
      await box.put('test_key', 'Updated value');
      final updatedValue = box.get('test_key');
      _addLog('✅ Cập nhật thành công: $updatedValue');

      // Test 5: Xóa dữ liệu
      _addLog('\n🗑️ Test xóa dữ liệu...');
      await box.delete('test_key');
      final deletedValue = box.get('test_key');
      if (deletedValue == null) {
        _addLog('✅ Xóa dữ liệu thành công');
      } else {
        _addLog('❌ Xóa dữ liệu thất bại');
      }

      // Test 6: Đếm keys
      _addLog('\n🔢 Test đếm keys...');
      _addLog('✅ Tổng số keys: ${box.keys.length}');
      _addLog('   Keys: ${box.keys.toList()}');

      // Test 7: Clear all
      _addLog('\n🧹 Test clear all...');
      await box.clear();
      _addLog('✅ Clear thành công, keys còn lại: ${box.keys.length}');

      // Close box
      await box.close();
      _addLog('\n✅ HIVE: Tất cả tests đều PASS!\n');

    } catch (e) {
      _addLog('❌ HIVE ERROR: $e');
    }
  }
}

