import 'package:flutter/material.dart';
import '../../presentation/pages/home/home_page.dart';
import '../config/app_config.dart';

/// HomeScreen - LingoFlow structure wrapper
/// Wraps existing HomePage logic with LingoFlow theme
class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // Use existing HomePage logic, but with LingoFlow structure
    if (AppConfig.useLingoFlowScreens) {
      return HomePage(userId: userId);
    }
    
    // Fallback to existing implementation
    return HomePage(userId: userId);
  }
}


