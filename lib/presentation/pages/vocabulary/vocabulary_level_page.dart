import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import '../../../core/services/tts_service.dart';
import '../../../data/datasources/local/vocabulary_seed_data.dart';
import 'vocabulary_learning_page.dart';

/// Trang hiển thị danh sách từ vựng theo level
class VocabularyLevelPage extends StatefulWidget {
  final String level;
  final String levelTitle;
  final String userId;

  const VocabularyLevelPage({
    super.key,
    required this.level,
    required this.levelTitle,
    required this.userId,
  });

  @override
  State<VocabularyLevelPage> createState() => _VocabularyLevelPageState();
}

class _VocabularyLevelPageState extends State<VocabularyLevelPage> {
  late List<Map<String, dynamic>> _vocabularyList;
  late List<Map<String, dynamic>> _filteredList;
  String _searchQuery = '';
  final TtsService _tts = TtsService();

  @override
  void initState() {
    super.initState();
    // Lọc từ vựng theo level
    _vocabularyList = VocabularySeedData.vocabularyData
        .where((word) => word['level'] == widget.level)
        .toList();
    _filteredList = _vocabularyList;
  }

  void _filterVocabulary(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredList = _vocabularyList;
      } else {
        _filteredList = _vocabularyList
            .where((word) =>
                word['word'].toString().toLowerCase().contains(_searchQuery) ||
                word['meaning'].toString().toLowerCase().contains(_searchQuery))
            .toList();
      }
    });
  }

  Color _getLevelColor() {
    switch (widget.level) {
      case 'A1':
        return const Color(0xFF4CAF50);
      case 'A2':
        return const Color(0xFF66BB6A);
      case 'B1':
        return const Color(0xFF2196F3);
      case 'B2':
        return const Color(0xFF1976D2);
      case 'C1':
        return const Color(0xFFFF9800);
      case 'C2':
        return const Color(0xFFF57C00);
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = _getLevelColor();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[50];

    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.levelTitle,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : levelColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Start Learning Button
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VocabularyLearningPage(
                      level: widget.level,
                      levelTitle: widget.levelTitle,
                      vocabularyList: _vocabularyList,
                      userId: widget.userId,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'Learn',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: levelColor,
              boxShadow: [
                BoxShadow(
                  color: levelColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '${_vocabularyList.length} Words',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.level == 'A1'
                      ? 'Perfect for beginners'
                      : widget.level == 'C2'
                          ? 'Master level vocabulary'
                          : 'Essential ${widget.level} vocabulary',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: _filterVocabulary,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: 'Search words...',
                hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: levelColor),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: levelColor, width: 2),
                ),
              ),
            ),
          ),

          // Word Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _searchQuery.isEmpty
                      ? 'All Words'
                      : 'Found ${_filteredList.length} words',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                if (_filteredList.isNotEmpty)
                  Text(
                    '${_filteredList.length} total',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: levelColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Vocabulary List
          Expanded(
            child: _filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No words found',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredList.length,
                    itemBuilder: (context, index) {
                      final word = _filteredList[index];
                      return _buildWordCard(word, levelColor);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(Map<String, dynamic> word, Color levelColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showWordDetail(word, levelColor);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Speaker Button
                GestureDetector(
                  onTap: () {
                    _tts.speak(word['word'].toString());
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: levelColor.withOpacity(isDark ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.volume_up_rounded,
                      color: levelColor,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Word Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              word['word'].toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: levelColor.withOpacity(isDark ? 0.2 : 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              word['partOfSpeech'].toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: levelColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (word['pronunciation'] != null &&
                          word['pronunciation'].toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            word['pronunciation'].toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: isDark ? Colors.grey[500] : Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      const SizedBox(height: 6),
                      Text(
                        word['meaning'].toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isDark ? Colors.grey[300] : Colors.black87,
                        ),
                      ),
                      if (word['example'] != null &&
                          word['example'].toString().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : Colors.grey[50],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '"${word['example']}"',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: isDark ? Colors.grey[400] : Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(Icons.chevron_right, color: isDark ? Colors.grey[600] : Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWordDetail(Map<String, dynamic> word, Color levelColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
          final textColor = isDark ? Colors.white : Colors.black87;
          final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

          return Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Content
                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.all(24),
                    children: [
                      // Word Header
                      Row(
                        children: [
                          // Speaker Button
                          GestureDetector(
                            onTap: () {
                              _tts.speak(word['word'].toString());
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: levelColor.withOpacity(isDark ? 0.2 : 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.volume_up_rounded, color: levelColor, size: 32),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  word['word'].toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                if (word['pronunciation'] != null)
                                  Text(
                                    word['pronunciation'].toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: subTextColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),

                    // Part of Speech & Level
                    Row(
                      children: [
                        _buildInfoChip(
                          word['partOfSpeech'].toString(),
                          levelColor,
                          Icons.category,
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          word['level'].toString(),
                          levelColor,
                          Icons.signal_cellular_alt,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Meaning
                    _buildSection(
                      'Meaning',
                      word['meaning'].toString(),
                      Icons.translate,
                      levelColor,
                    ),

                    // Example
                    if (word['example'] != null &&
                        word['example'].toString().isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildSection(
                        'Example',
                        word['example'].toString(),
                        Icons.format_quote,
                        levelColor,
                      ),
                      if (word['exampleTranslation'] != null &&
                          word['exampleTranslation'].toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            word['exampleTranslation'].toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],

                    // Synonyms
                    if (word['synonyms'] != null &&
                        (word['synonyms'] as List).isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildListSection(
                        'Synonyms',
                        (word['synonyms'] as List)
                            .map((e) => e.toString())
                            .toList(),
                        Icons.swap_horiz,
                        levelColor,
                        Colors.green,
                      ),
                    ],

                    // Antonyms
                    if (word['antonyms'] != null &&
                        (word['antonyms'] as List).isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildListSection(
                        'Antonyms',
                        (word['antonyms'] as List)
                            .map((e) => e.toString())
                            .toList(),
                        Icons.compare_arrows,
                        levelColor,
                        Colors.red,
                      ),
                    ],

                      const SizedBox(height: 24),

                      // Speak Example Button
                      if (word['example'] != null &&
                          word['example'].toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GFButton(
                            onPressed: () {
                              _tts.speak(word['example'].toString());
                            },
                            text: 'Listen to Example',
                            color: Colors.blue,
                            size: GFSize.MEDIUM,
                            shape: GFButtonShape.pills,
                            icon: const Icon(Icons.play_circle_outline,
                                color: Colors.white),
                            textStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      // Add to Practice Button
                      GFButton(
                        onPressed: () {
                          Navigator.pop(context);
                          GFToast.showToast(
                            'Added "${word['word']}" to practice list!',
                            context,
                            toastPosition: GFToastPosition.BOTTOM,
                            backgroundColor: levelColor,
                          );
                        },
                        text: 'Add to Practice',
                        color: levelColor,
                        size: GFSize.LARGE,
                        shape: GFButtonShape.pills,
                        icon: const Icon(Icons.add_circle_outline,
                            color: Colors.white),
                        textStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      String title, String content, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListSection(String title, List<String> items, IconData icon,
      Color mainColor, Color chipColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: mainColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (item) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: chipColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: chipColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: chipColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

