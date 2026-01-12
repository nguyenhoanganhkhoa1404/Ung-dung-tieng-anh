import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// AIChatScreen - Messaging app style
/// AI bubble (light blue, left), User bubble (white with Ocean Blue border, right)
/// Smart Reply chips above input, Microphone + keyboard icons
/// Grammar correction tooltip (yellow highlight)
class AIChatScreen extends StatefulWidget {
  final String userId;

  const AIChatScreen({
    super.key,
    required this.userId,
  });

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            text: 'That\'s a great question! Let me help you with that.',
            isUser: false,
            timestamp: DateTime.now(),
            grammarCorrection: text.contains('grammar') 
                ? 'Consider using "grammar" instead of "grammer"'
                : null,
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.enableAIChat) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AI Chat'),
        ),
        body: const Center(
          child: Text('AI Chat is disabled'),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? LingoFlowColors.darkBackground : Colors.grey[50];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('AI Chat'),
        backgroundColor: LingoFlowColors.oceanBlue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Smart Reply chips
          if (_messages.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: [
                  _buildSmartReplyChip('Hello!', () => _sendMessage('Hello!')),
                  _buildSmartReplyChip('Help me practice', () => _sendMessage('Help me practice')),
                  _buildSmartReplyChip('Grammar question', () => _sendMessage('Grammar question')),
                ],
              ),
            ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? LingoFlowColors.darkCardBackground : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: LingoFlowColors.oceanBlue,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.mic_rounded),
                  color: LingoFlowColors.oceanBlue,
                  onPressed: () {
                    // TODO: Implement voice input
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  color: LingoFlowColors.oceanBlue,
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: LingoFlowColors.oceanBlue,
              child: const Icon(Icons.smart_toy_rounded, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? Colors.white
                        : LingoFlowColors.aiBubbleLight,
                    border: message.isUser
                        ? Border.all(color: LingoFlowColors.userBubbleBorder, width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.text,
                    style: LingoFlowTypography.bodyLarge(context),
                  ),
                ),
                if (message.grammarCorrection != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: LingoFlowColors.grammarHighlight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lightbulb_outline, size: 16),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            message.grammarCorrection!,
                            style: LingoFlowTypography.bodySmall(context),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: LingoFlowColors.oceanBlue,
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: LingoFlowColors.oceanBlue,
            child: const Icon(Icons.smart_toy_rounded, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: LingoFlowColors.aiBubbleLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const SizedBox(
              width: 40,
              height: 20,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartReplyChip(String text, VoidCallback onTap) {
    return ActionChip(
      label: Text(text),
      onPressed: onTap,
      backgroundColor: LingoFlowColors.oceanBlue.withOpacity(0.1),
      labelStyle: TextStyle(color: LingoFlowColors.oceanBlue),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? grammarCorrection;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.grammarCorrection,
  });
}


