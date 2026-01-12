import 'package:flutter/material.dart';
import '../../presentation/pages/vocabulary/vocabulary_page.dart';
import '../config/app_config.dart';

/// LibraryScreen - LingoFlow structure wrapper
/// Wraps existing VocabularyPage logic with Library structure
class LibraryScreen extends StatelessWidget {
  final String userId;

  const LibraryScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // Use existing VocabularyPage logic, but with LingoFlow structure
    if (AppConfig.useLingoFlowScreens) {
      return VocabularyPage(userId: userId);
    }
    
    // Fallback to existing implementation
    return VocabularyPage(userId: userId);
  }
}


