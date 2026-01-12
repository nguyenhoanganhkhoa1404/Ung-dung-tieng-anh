import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class WritingLessonPage extends StatefulWidget {
  final String title;
  final String prompt;
  final int minWords;
  
  const WritingLessonPage({
    super.key,
    required this.title,
    required this.prompt,
    required this.minWords,
  });

  @override
  State<WritingLessonPage> createState() => _WritingLessonPageState();
}

class _WritingLessonPageState extends State<WritingLessonPage> {
  final TextEditingController _textController = TextEditingController();
  bool _showFeedback = false;
  int _wordCount = 0;
  String _feedback = '';
  int _score = 0;
  
  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateWordCount);
  }
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  void _updateWordCount() {
    final text = _textController.text.trim();
    final words = text.isEmpty ? [] : text.split(RegExp(r'\s+'));
    setState(() {
      _wordCount = words.length;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _showFeedback ? _buildFeedbackView() : _buildWritingView(),
    );
  }
  
  Widget _buildWritingView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPromptSection(),
                _buildWritingArea(),
              ],
            ),
          ),
        ),
        _buildSubmitButton(),
      ],
    );
  }
  
  Widget _buildPromptSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: AppColors.writingColor.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, color: AppColors.writingColor, size: 32),
              const SizedBox(width: 12),
              Text(
                'Đề bài',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.prompt,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.writingColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, size: 18, color: AppColors.writingColor),
                const SizedBox(width: 8),
                Text(
                  'Tối thiểu ${widget.minWords} từ',
                  style: TextStyle(
                    color: AppColors.writingColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWritingArea() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bài viết của bạn',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _wordCount >= widget.minWords 
                      ? AppColors.successColor.withOpacity(0.2)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$_wordCount / ${widget.minWords} từ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _wordCount >= widget.minWords 
                        ? AppColors.successColor
                        : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            maxLines: 15,
            decoration: InputDecoration(
              hintText: 'Bắt đầu viết bài của bạn...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.writingColor, width: 2),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSubmitButton() {
    final canSubmit = _wordCount >= widget.minWords;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canSubmit ? _submitEssay : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.writingColor,
            ),
            child: Text(
              canSubmit 
                  ? 'Nộp bài'
                  : 'Cần viết thêm ${widget.minWords - _wordCount} từ',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
  
  void _submitEssay() {
    // Simple scoring based on word count and basic checks
    final text = _textController.text;
    int score = 0;
    List<String> feedbackPoints = [];
    
    // Check word count
    if (_wordCount >= widget.minWords) {
      score += 30;
      feedbackPoints.add('✅ Đạt yêu cầu số từ ($_wordCount từ)');
    }
    
    // Check for capital letters
    if (RegExp(r'[A-Z]').hasMatch(text)) {
      score += 20;
      feedbackPoints.add('✅ Sử dụng chữ hoa đúng cách');
    }
    
    // Check for punctuation
    if (RegExp(r'[.,!?]').hasMatch(text)) {
      score += 20;
      feedbackPoints.add('✅ Sử dụng dấu câu');
    }
    
    // Check for variety (different words)
    final words = text.toLowerCase().split(RegExp(r'\s+'));
    final uniqueWords = words.toSet();
    if (uniqueWords.length / words.length > 0.6) {
      score += 30;
      feedbackPoints.add('✅ Từ vựng đa dạng');
    } else {
      feedbackPoints.add('⚠️ Nên sử dụng thêm từ vựng đa dạng');
    }
    
    setState(() {
      _score = score;
      _feedback = feedbackPoints.join('\n');
      _showFeedback = true;
    });
  }
  
  Widget _buildFeedbackView() {
    final xpEarned = _score;
    
    String message;
    IconData icon;
    Color color;
    
    if (_score >= 80) {
      message = 'Tuyệt vời!';
      icon = Icons.emoji_events;
      color = AppColors.goldColor;
    } else if (_score >= 60) {
      message = 'Tốt lắm!';
      icon = Icons.thumb_up;
      color = AppColors.successColor;
    } else {
      message = 'Cố gắng thêm nhé!';
      icon = Icons.favorite;
      color = AppColors.primaryColor;
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Icon(icon, size: 80, color: color),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$_score/100 điểm',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.goldColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '+$xpEarned XP',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.goldColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Nhận xét',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _feedback,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Bài viết của bạn',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _textController.text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Về danh sách'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _textController.clear();
                      _showFeedback = false;
                      _wordCount = 0;
                      _score = 0;
                      _feedback = '';
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Viết lại'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.writingColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

