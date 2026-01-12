import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../theme/colors.dart';
import '../screens/home_screen.dart';
import '../screens/library_screen.dart';
import '../screens/ai_chat_screen.dart';
import '../screens/profile_screen.dart';
import '../../presentation/pages/main/main_page.dart';

/// AppNavigator - BottomTab + Stack navigation
/// LingoFlow navigation structure with 4 tabs: Home, Library, AI Chat, Profile
class AppNavigator extends StatefulWidget {
  final String userId;

  const AppNavigator({
    super.key,
    required this.userId,
  });

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.useLingoFlowNavigation) {
      // Fallback to existing MainPage
      return MainPage();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(userId: widget.userId),
          LibraryScreen(userId: widget.userId),
          AIChatScreen(userId: widget.userId),
          ProfileScreen(userId: widget.userId),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(isDark),
    );
  }

  Widget _buildBottomNavBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? LingoFlowColors.darkCardBackground : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home', isDark),
              _buildNavItem(1, Icons.library_books_rounded, 'Library', isDark),
              _buildNavItem(2, Icons.chat_bubble_rounded, 'AI Chat', isDark),
              _buildNavItem(3, Icons.person_rounded, 'Profile', isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = _currentIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? LingoFlowColors.oceanBlue.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? LingoFlowColors.oceanBlue
                    : (isDark ? Colors.grey[600] : Colors.grey[400]),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? LingoFlowColors.oceanBlue
                    : (isDark ? Colors.grey[600] : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


