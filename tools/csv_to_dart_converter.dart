import 'dart:io';
import 'dart:convert';

/// Script để chuyển đổi file CSV từ vựng sang Dart code
void main() async {
  // Đường dẫn file CSV
  final csvFile = File(r'd:\Download\Từ vựng - C2.csv');
  final outputFile = File(r'c:\File Coding\ung_dung_hoc_tieng_anh\lib\data\datasources\local\vocabulary_seed_data.dart');
  
  print('Đang đọc file CSV: ${csvFile.path}');
  
  if (!await csvFile.exists()) {
    print('Lỗi: File CSV không tồn tại!');
    return;
  }
  
  // Đọc toàn bộ nội dung file
  final lines = await csvFile.readAsLines(encoding: utf8);
  
  print('Đã đọc ${lines.length} dòng từ file CSV');
  
  if (lines.isEmpty) {
    print('Lỗi: File CSV rỗng!');
    return;
  }
  
  // Dòng đầu tiên là header
  final header = lines[0].split(',');
  print('Header: $header');
  
  // Parse dữ liệu
  final vocabularyList = <Map<String, dynamic>>[];
  
  for (int i = 1; i < lines.length; i++) {
    final line = lines[i];
    if (line.trim().isEmpty) continue;
    
    try {
      final vocabItem = parseCsvLine(line);
      if (vocabItem != null && vocabItem['word']?.toString().isNotEmpty == true) {
        vocabularyList.add(vocabItem);
      }
    } catch (e) {
      print('Lỗi ở dòng ${i + 1}: $e');
    }
  }
  
  print('Đã parse thành công ${vocabularyList.length} từ vựng');
  
  // Thống kê
  final levelStats = <String, int>{};
  for (var item in vocabularyList) {
    final level = item['level'] as String;
    levelStats[level] = (levelStats[level] ?? 0) + 1;
  }
  
  print('\nThống kê theo cấp độ:');
  levelStats.forEach((level, count) {
    print('  $level: $count từ');
  });
  
  // Tạo file Dart
  print('\nĐang tạo file Dart...');
  final dartContent = generateDartContent(vocabularyList);
  
  // Tạo thư mục nếu chưa tồn tại
  await outputFile.parent.create(recursive: true);
  
  // Ghi file
  await outputFile.writeAsString(dartContent, encoding: utf8);
  
  print('✅ Đã tạo file thành công: ${outputFile.path}');
  print('Tổng số từ vựng: ${vocabularyList.length}');
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
  
  return text
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

/// Tạo nội dung file Dart
String generateDartContent(List<Map<String, dynamic>> vocabularyList) {
  final buffer = StringBuffer();
  
  // Header
  buffer.writeln('// Dữ liệu từ vựng được chuyển đổi từ CSV');
  buffer.writeln('// Tổng số từ: ${vocabularyList.length}');
  buffer.writeln('// Tự động tạo bởi csv_to_dart_converter.dart');
  buffer.writeln();
  buffer.writeln('class VocabularySeedData {');
  buffer.writeln('  static const List<Map<String, dynamic>> vocabularyData = [');
  
  // Thêm từng từ vựng
  for (int i = 0; i < vocabularyList.length; i++) {
    final item = vocabularyList[i];
    
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
    
    // Thêm dấu phẩy nếu không phải item cuối
    if (i < vocabularyList.length - 1) {
      buffer.write(',');
    }
    buffer.writeln();
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
  buffer.writeln('    final counts = <String, int>{};');
  buffer.writeln('    for (var word in vocabularyData) {');
  buffer.writeln("      final level = word['level'] as String;");
  buffer.writeln('      counts[level] = (counts[level] ?? 0) + 1;');
  buffer.writeln('    }');
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
  buffer.writeln('}');
  
  return buffer.toString();
}

