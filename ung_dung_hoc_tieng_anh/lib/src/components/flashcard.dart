import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../config/app_config.dart';

/// Flashcard Component
/// Displays image, word text, and record button with animation
class Flashcard extends StatefulWidget {
  final String? imageUrl;
  final String word;
  final String? phonetic;
  final VoidCallback? onRecord;
  final VoidCallback? onSpeaker;
  final bool isRecording;
  
  const Flashcard({
    super.key,
    this.imageUrl,
    required this.word,
    this.phonetic,
    this.onRecord,
    this.onSpeaker,
    this.isRecording = false,
  });

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    if (AppConfig.enableFlashcardAnimation) {
      _pulseController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      )..repeat(reverse: true);
      
      _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? LingoFlowColors.darkCardBackground : Colors.white;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.25)
                : Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image placeholder or actual image
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: LingoFlowColors.grayLight,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: widget.imageUrl != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      widget.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                    ),
                  )
                : _buildPlaceholder(),
          ),
          
          // Word and phonetic
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.word,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    if (widget.onSpeaker != null)
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded),
                        color: LingoFlowColors.oceanBlue,
                        iconSize: 22,
                        onPressed: widget.onSpeaker,
                      ),
                  ],
                ),
                if (widget.phonetic != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    widget.phonetic!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 56,
        color: LingoFlowColors.gray.withOpacity(0.5),
      ),
    );
  }

  /// Build the record button with pulse animation
  Widget buildRecordButton() {
    if (!AppConfig.enableFlashcardAnimation) {
      return _buildStaticRecordButton();
    }
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isRecording ? _pulseAnimation.value : 1.0,
          child: _buildStaticRecordButton(),
        );
      },
    );
  }

  Widget _buildStaticRecordButton() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: LingoFlowColors.oceanBlue,
        boxShadow: [
          BoxShadow(
            color: LingoFlowColors.oceanBlue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onRecord,
          borderRadius: BorderRadius.circular(40),
          child: Center(
            child: Icon(
              widget.isRecording ? Icons.stop_rounded : Icons.mic_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}


