import 'dart:io';
import 'dart:convert';

/// Script để chuyển đổi TẤT CẢ các file CSV từ vựng (A1-C2) sang Dart code
/// 
/// Chạy: dart run tools/convert_all_csv_to_dart.dart
void main() async {
  print('🚀 Bắt đầu chuyển đổi TẤT CẢ file CSV sang Dart...\n');
  
  // Danh sách các file CSV cần chuyển đổi
  final csvFiles = [
    {'level': 'A1', 'path': r'd:\Download\Từ vựng - A1.csv'},
    {'level': 'A2', 'path': r'd:\Download\Từ vựng - A2.csv'},
    {'level': 'B1', 'path': r'd:\Download\Từ vựng - B1.csv'},
    {'level': 'B2', 'path': r'd:\Download\Từ vựng - B2.csv'},
    {'level': 'C1', 'path': r'd:\Download\Từ vựng - C1.csv'},
    {'level': 'C2', 'path': r'd:\Download\Từ vựng - C2.csv'},
  ];
  
  final outputFile = File(r'c:\File Coding\ung_dung_hoc_tieng_anh\lib\data\datasources\local\vocabulary_seed_data.dart');
  
  // Tổng hợp tất cả từ vựng từ các file
  final allVocabulary = <Map<String, dynamic>>[];
  final levelStats = <String, int>{};
  
  // Đọc và parse từng file CSV
  for (var fileInfo in csvFiles) {
    final level = fileInfo['level'] as String;
    final path = fileInfo['path'] as String;
    final file = File(path);
    
    print('📖 Đang đọc file: ${file.path}');
    
    if (!await file.exists()) {
      print('⚠️  File không tồn tại, bỏ qua: $path');
      continue;
    }
    
    try {
      final lines = await file.readAsLines(encoding: utf8);
      
      if (lines.isEmpty) {
        print('⚠️  File rỗng, bỏ qua: $path');
        continue;
      }
      
      // Bỏ qua header (dòng đầu tiên)
      for (int i = 1; i < lines.length; i++) {
        final line = lines[i];
        if (line.trim().isEmpty) continue;
        
        try {
          final vocabItem = parseCsvLine(line);
          if (vocabItem != null && vocabItem['word']?.toString().isNotEmpty == true) {
            allVocabulary.add(vocabItem);
            levelStats[level] = (levelStats[level] ?? 0) + 1;
          }
        } catch (e) {
          print('⚠️  Lỗi ở dòng ${i + 1} của $level: $e');
        }
      }
      
      print('✅ Đã đọc $level: ${levelStats[level]} từ\n');
    } catch (e) {
      print('❌ Lỗi khi đọc file $level: $e\n');
    }
  }
  
  if (allVocabulary.isEmpty) {
    print('❌ Không có dữ liệu để chuyển đổi!');
    return;
  }
  
  print('━' * 60);
  print('📊 Tổng số từ vựng: ${allVocabulary.length}');
  print('\n📈 Phân bổ theo cấp độ:');
  levelStats.forEach((level, count) {
    print('  $level: $count từ');
  });
  print('━' * 60);
  
  // Tạo file Dart
  print('\n🔨 Đang tạo file Dart...');
  final dartContent = generateDartContent(allVocabulary);
  
  // Tạo thư mục nếu chưa tồn tại
  await outputFile.parent.create(recursive: true);
  
  // Ghi file
  await outputFile.writeAsString(dartContent, encoding: utf8);
  
  print('✅ Đã tạo file thành công: ${outputFile.path}');
  print('\n🎉 HOÀN THÀNH!');
  print('   Tổng số từ vựng: ${allVocabulary.length}');
  print('   Các cấp độ: ${levelStats.keys.join(', ')}');
  print('━' * 60);
}

/// Parse một dòng CSV, xử lý trường hợp có dấu phẩy trong dấu ngoặc kép
Map<String, dynamic>? parseCsvLine(String line) {
  final fields = <String>[];
  var current = StringBuffer();
  var inQuotes = false;
  
  for (int i = 0; i < line.length; i++) {
    final char = line[i];
    
    if (char == '"') {
      inQuotes = !inQuotes;
    } else if (char == ',' && !inQuotes) {
      fields.add(current.toString().trim());
      current = StringBuffer();
    } else {
      current.write(char);
    }
  }
  
  // Thêm field cuối cùng
  fields.add(current.toString().trim());
  
  // Đảm bảo có đủ 11 cột
  while (fields.length < 11) {
    fields.add('');
  }
  
  return {
    'word': cleanString(fields[1]),
    'pronunciation': cleanString(fields[2]),
    'meaning': cleanString(fields[3]),
    'partOfSpeech': cleanString(fields[4]),
    'level': cleanString(fields[5]),
    'example': cleanString(fields[6]),
    'exampleTranslation': cleanString(fields[7]),
    'imageUrl': cleanString(fields[8]),
    'synonyms': parseList(fields[9]),
    'antonyms': parseList(fields[10]),
  };
}

/// Làm sạch chuỗi, xử lý escape characters
String cleanString(String text) {
  text = text.trim();
  
  // Loại bỏ dấu ngoặc kép ở đầu và cuối nếu có
  if (text.startsWith('"') && text.endsWith('"')) {
    text = text.substring(1, text.length - 1);
  }
  
  // Escape các ký tự đặc biệt cho Dart
  text = text.replaceAll('\\', '\\\\');
  text = text.replaceAll("'", "\\'");
  text = text.replaceAll('\n', '\\n');
  text = text.replaceAll('\r', '');
  text = text.replaceAll('\$', '\\\$');
  
  return text;
}

/// Parse list từ chuỗi phân cách bằng dấu phẩy
List<String> parseList(String text) {
  if (text.isEmpty) return [];
  
  text = cleanString(text);
  
  // Xử lý trường hợp "—" (không có)
  if (text == '—' || text == '-' || text == '–') return [];
  
  return text
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty && e != '—' && e != '-')
      .toList();
}

/// Tạo nội dung file Dart
String generateDartContent(List<Map<String, dynamic>> vocabularyList) {
  final buffer = StringBuffer();
  
  // Header
  buffer.writeln('// ============================================================================');
  buffer.writeln('// Dữ liệu từ vựng đầy đủ - Tất cả cấp độ từ A1 đến C2');
  buffer.writeln('// Tự động tạo bởi convert_all_csv_to_dart.dart');
  buffer.writeln('// ============================================================================');
  buffer.writeln('// Tổng số từ: ${vocabularyList.length}');
  
  // Thống kê theo level
  final levelCount = <String, int>{};
  for (var item in vocabularyList) {
    final level = item['level'] as String;
    levelCount[level] = (levelCount[level] ?? 0) + 1;
  }
  
  buffer.writeln('//');
  buffer.writeln('// Phân bổ theo cấp độ:');
  levelCount.forEach((level, count) {
    buffer.writeln('//   $level: $count từ');
  });
  buffer.writeln('// ============================================================================');
  buffer.writeln();
  buffer.writeln('class VocabularySeedData {');
  buffer.writeln('  static const List<Map<String, dynamic>> vocabularyData = [');
  
  // Nhóm theo level để dễ đọc
  final groupedByLevel = <String, List<Map<String, dynamic>>>{};
  for (var item in vocabularyList) {
    final level = item['level'] as String;
    groupedByLevel.putIfAbsent(level, () => []).add(item);
  }
  
  // Sắp xếp theo thứ tự level
  final orderedLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
  
  var isFirst = true;
  for (var level in orderedLevels) {
    final items = groupedByLevel[level];
    if (items == null || items.isEmpty) continue;
    
    if (!isFirst) {
      buffer.writeln();
    }
    isFirst = false;
    
    buffer.writeln('    // ==================== $level LEVEL (${items.length} words) ====================');
    
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      
      buffer.writeln('    {');
      buffer.writeln("      'word': '${item['word']}',");
      buffer.writeln("      'pronunciation': '${item['pronunciation']}',");
      buffer.writeln("      'meaning': '${item['meaning']}',");
      buffer.writeln("      'partOfSpeech': '${item['partOfSpeech']}',");
      buffer.writeln("      'level': '${item['level']}',");
      buffer.writeln("      'example': '${item['example']}',");
      buffer.writeln("      'exampleTranslation': '${item['exampleTranslation']}',");
      buffer.writeln("      'imageUrl': '${item['imageUrl']}',");
      
      // Synonyms
      final synonyms = item['synonyms'] as List<String>;
      final synonymsStr = synonyms.map((s) => "'$s'").join(', ');
      buffer.writeln("      'synonyms': [$synonymsStr],");
      
      // Antonyms
      final antonyms = item['antonyms'] as List<String>;
      final antonymsStr = antonyms.map((s) => "'$s'").join(', ');
      buffer.writeln("      'antonyms': [$antonymsStr],");
      
      buffer.write('    }');
      
      // Thêm dấu phẩy nếu không phải item cuối cùng của level cuối
      final isLastLevel = level == orderedLevels.last;
      final isLastItem = i == items.length - 1;
      
      if (!isLastLevel || !isLastItem) {
        buffer.write(',');
      }
      buffer.writeln();
    }
  }
  
  buffer.writeln('  ];');
  buffer.writeln();
  
  // Utility functions
  buffer.writeln('  /// Lấy danh sách từ theo cấp độ');
  buffer.writeln('  static List<Map<String, dynamic>> getWordsByLevel(String level) {');
  buffer.writeln("    return vocabularyData.where((word) => word['level'] == level).toList();");
  buffer.writeln('  }');
  buffer.writeln();
  
  buffer.writeln('  /// Lấy từ ngẫu nhiên cho luyện tập hàng ngày');
  buffer.writeln('  static List<Map<String, dynamic>> getDailyWords(int count) {');
  buffer.writeln('    final shuffled = List<Map<String, dynamic>>.from(vocabularyData)..shuffle();');
  buffer.writeln('    return shuffled.take(count).toList();');
  buffer.writeln('  }');
  buffer.writeln();
  
  buffer.writeln('  /// Lấy từ theo loại từ (noun, verb, adjective, etc.)');
  buffer.writeln('  static List<Map<String, dynamic>> getWordsByPartOfSpeech(String partOfSpeech) {');
  buffer.writeln("    return vocabularyData.where((word) => word['partOfSpeech'] == partOfSpeech).toList();");
  buffer.writeln('  }');
  buffer.writeln();
  
  buffer.writeln('  /// Lấy tổng số từ');
  buffer.writeln('  static int getTotalWordCount() {');
  buffer.writeln('    return vocabularyData.length;');
  buffer.writeln('  }');
  buffer.writeln();
  
  buffer.writeln('  /// Thống kê số lượng từ theo cấp độ');
  buffer.writeln('  static Map<String, int> getWordCountByLevel() {');
  buffer.writeln('    final counts = <String, int>{');
  levelCount.forEach((level, count) {
    buffer.writeln("      '$level': $count,");
  });
  buffer.writeln('    };');
  buffer.writeln('    return counts;');
  buffer.writeln('  }');
  buffer.writeln();
  
  buffer.writeln('  /// Tìm kiếm từ theo keyword');
  buffer.writeln('  static List<Map<String, dynamic>> searchWords(String keyword) {');
  buffer.writeln('    final lowerKeyword = keyword.toLowerCase();');
  buffer.writeln('    return vocabularyData.where((word) {');
  buffer.writeln("      final wordText = (word['word'] as String).toLowerCase();");
  buffer.writeln("      final meaning = (word['meaning'] as String).toLowerCase();");
  buffer.writeln('      return wordText.contains(lowerKeyword) || meaning.contains(lowerKeyword);');
  buffer.writeln('    }).toList();');
  buffer.writeln('  }');
  buffer.writeln();
  
  buffer.writeln('  /// Lấy các từ trong một khoảng cấp độ');
  buffer.writeln('  static List<Map<String, dynamic>> getWordsInLevelRange(List<String> levels) {');
  buffer.writeln("    return vocabularyData.where((word) => levels.contains(word['level'])).toList();");
  buffer.writeln('  }');
  buffer.writeln('}');
  
  return buffer.toString();
}

