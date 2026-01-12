import 'package:flutter/material.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../config/app_config.dart';

/// ProfileScreen - LingoFlow structure wrapper
/// Wraps existing ProfilePage logic with LingoFlow theme
class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // Use existing ProfilePage logic, but with LingoFlow structure
    if (AppConfig.useLingoFlowScreens) {
      return ProfilePage(userId: userId);
    }
    
    // Fallback to existing implementation
    return ProfilePage(userId: userId);
  }
}


