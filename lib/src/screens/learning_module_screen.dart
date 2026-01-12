import 'package:flutter/material.dart';
import '../../presentation/pages/vocabulary/vocabulary_learning_page.dart';
import '../config/app_config.dart';

/// LearningModuleScreen - Vocabulary Flashcard
/// Thin progress bar at top, central flashcard, glowing microphone button
class LearningModuleScreen extends StatelessWidget {
  final String level;
  final String levelTitle;
  final List<Map<String, dynamic>> vocabularyList;
  final String userId;

  const LearningModuleScreen({
    super.key,
    required this.level,
    required this.levelTitle,
    required this.vocabularyList,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // Use existing VocabularyLearningPage logic, but with LingoFlow structure
    if (AppConfig.useLingoFlowScreens) {
      return VocabularyLearningPage(
        level: level,
        levelTitle: levelTitle,
        vocabularyList: vocabularyList,
        userId: userId,
      );
    }
    
    // Fallback to existing implementation
    return VocabularyLearningPage(
      level: level,
      levelTitle: levelTitle,
      vocabularyList: vocabularyList,
      userId: userId,
    );
  }
}

