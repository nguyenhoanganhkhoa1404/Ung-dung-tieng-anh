import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../data/datasources/local/vocabulary_seed_data.dart';
import '../firebase_options.dart';

/// Script để import từ vựng từ seed data vào Firebase Firestore
/// 
/// Chạy script này bằng lệnh:
/// flutter run -t lib/tools/import_vocabulary_to_firestore.dart
Future<void> main() async {
  print('🚀 Bắt đầu import từ vựng vào Firebase Firestore...\n');
  
  // Khởi tạo Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Đã kết nối Firebase thành công!\n');
  } catch (e) {
    print('❌ Lỗi khi kết nối Firebase: $e');
    return;
  }
  
  final firestore = FirebaseFirestore.instance;
  final vocabularyCollection = firestore.collection('vocabulary');
  
  // Lấy dữ liệu từ seed data
  final vocabularyData = VocabularySeedData.vocabularyData;
  
  print('📊 Tổng số từ vựng cần import: ${vocabularyData.length}');
  print('━' * 60);
  
  // Thống kê
  int successCount = 0;
  int errorCount = 0;
  int skipCount = 0;
  
  final levelStats = <String, int>{};
  
  // Import từng từ vào Firestore
  for (int i = 0; i < vocabularyData.length; i++) {
    final vocab = vocabularyData[i];
    final word = vocab['word'] as String;
    final level = vocab['level'] as String;
    
    // Tạo ID duy nhất từ word (loại bỏ ký tự đặc biệt)
    final docId = _createDocId(word, i);
    
    try {
      // Kiểm tra xem từ đã tồn tại chưa
      final docRef = vocabularyCollection.doc(docId);
      final docSnapshot = await docRef.get();
      
      if (docSnapshot.exists) {
        // Nếu đã tồn tại, bỏ qua hoặc update
        print('⏭️  Bỏ qua từ đã tồn tại: "$word" (${i + 1}/${vocabularyData.length})');
        skipCount++;
        continue;
      }
      
      // Tạo document mới
      final data = {
        'word': vocab['word'],
        'pronunciation': vocab['pronunciation'] ?? '',
        'meaning': vocab['meaning'],
        'partOfSpeech': vocab['partOfSpeech'] ?? 'noun',
        'level': vocab['level'] ?? 'A1',
        'example': vocab['example'] ?? '',
        'exampleTranslation': vocab['exampleTranslation'] ?? '',
        'imageUrl': vocab['imageUrl'] ?? '',
        'audioUrl': '', // Có thể thêm sau
        'synonyms': List<String>.from(vocab['synonyms'] ?? []),
        'antonyms': List<String>.from(vocab['antonyms'] ?? []),
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      // Lưu vào Firestore
      await docRef.set(data);
      
      // Cập nhật thống kê
      successCount++;
      levelStats[level] = (levelStats[level] ?? 0) + 1;
      
      // Hiển thị tiến trình
      if ((i + 1) % 50 == 0 || i == vocabularyData.length - 1) {
        final progress = ((i + 1) / vocabularyData.length * 100).toStringAsFixed(1);
        print('✅ Đang xử lý: $progress% (${i + 1}/${vocabularyData.length}) - "$word"');
      }
      
      // Delay nhỏ để tránh quá tải Firebase (optional)
      if ((i + 1) % 50 == 0) {
        await Future.delayed(Duration(milliseconds: 500));
      }
      
    } catch (e) {
      errorCount++;
      print('❌ Lỗi khi import "$word": $e');
    }
  }
  
  // Báo cáo kết quả
  print('\n' + '━' * 60);
  print('🎉 HOÀN THÀNH IMPORT!\n');
  print('📊 Thống kê:');
  print('  ✅ Thành công: $successCount từ');
  print('  ⏭️  Bỏ qua (đã tồn tại): $skipCount từ');
  print('  ❌ Lỗi: $errorCount từ');
  print('  📝 Tổng cộng: ${vocabularyData.length} từ');
  
  print('\n📈 Phân bổ theo cấp độ:');
  levelStats.forEach((level, count) {
    print('  $level: $count từ');
  });
  
  print('\n✨ Bạn có thể xem dữ liệu tại Firebase Console:');
  print('   https://console.firebase.google.com/project/ung-dung-hoc-tieng-anh-348fd/firestore');
  print('━' * 60);
}

/// Tạo document ID từ từ vựng
String _createDocId(String word, int index) {
  // Loại bỏ ký tự đặc biệt và khoảng trắng
  String cleanWord = word
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  
  // Giới hạn độ dài
  if (cleanWord.length > 50) {
    cleanWord = cleanWord.substring(0, 50);
  }
  
  // Thêm index để đảm bảo unique
  return '${cleanWord}_$index';
}

