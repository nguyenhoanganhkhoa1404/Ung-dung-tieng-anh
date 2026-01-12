import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../../../core/l10n/app_localizations.dart';
import '../home/home_page.dart';
import '../vocabulary/random_vocabulary_page.dart';
import '../profile/profile_page.dart';
import '../dashboard/dashboard_page.dart';
import '../../../src/screens/flashcard_screen.dart';
import '../../../data/repositories/analytics_repository_impl.dart';
import '../../../domain/services/analytics_service.dart';

/// Màn hình chính với Bottom Navigation
/// 4 tabs: Home, Dashboard, Leaderboard, Profile
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  String _userId = 'demo_user';
  late final AnalyticsService _analyticsService;
  late final AnalyticsRepositoryImpl _analyticsRepository;
  StreamSubscription<User?>? _authSub;

  @override
  void initState() {
    super.initState();
    // Khởi tạo Analytics Service
    _analyticsRepository = AnalyticsRepositoryImpl();
    _analyticsService = AnalyticsService(_analyticsRepository);

    // Bind userId to auth state (avoid being stuck on demo_user when auth loads late)
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      final nextId = user?.uid ?? 'demo_user';
      if (nextId == _userId) return;

      setState(() {
        _userId = nextId;
        // Safety: if auth state changes, go back to Home
        _currentIndex = 0;
      });

      if (user != null) {
        _ensureUserProfileExists(user);
      }
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      Future.microtask(() => _ensureUserProfileExists(user));
    }
  }

  Future<void> _ensureUserProfileExists(User user) async {
    try {
      final existing = await _analyticsRepository.getUserProfile(user.uid);
      if (existing != null) return;

      final name = user.displayName ??
          (user.email?.split('@').first ?? 'User');
      final email = user.email ?? '';

      await _analyticsRepository.createUser(
        userId: user.uid,
        name: name,
        email: email,
      );
    } catch (_) {
      // Non-fatal: dashboard will still show 0 if profile missing
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  List<Widget> get _pages => [
        HomePage(userId: _userId),
        DashboardPage(
          userId: _userId,
          analyticsService: _analyticsService,
        ),
        RandomVocabularyPage(userId: _userId),
        FlashcardScreen(userId: _userId), // Thay Leaderboard bằng Flashcard
        ProfilePage(userId: _userId),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildModernBottomNavBar(),
    );
  }

  Widget _buildModernBottomNavBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Layout: 4 items + 1 center circular "Learning" button (FAB style)
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 84,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Bottom bar background with subtle gradient
            Container(
              height: 68,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E1E1E), const Color(0xFF252530)]
                      : [const Color(0xFFFDFDFF), const Color(0xFFF8F7FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? const Color(0xFF6C63FF).withOpacity(0.15)
                        : const Color(0xFF6C63FF).withOpacity(0.08),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.4)
                        : const Color(0xFF6C63FF).withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    _buildNavItem(0, Icons.home_rounded, context.l10n.t('nav_home')),
                    _buildNavItem(1, Icons.bar_chart_rounded, context.l10n.t('nav_board')),
                    const SizedBox(width: 56), // space for center button
                    _buildNavItem(3, Icons.style_rounded, 'Flashcard'), // Thay Leaderboard bằng Flashcard
                    _buildNavItem(4, Icons.person_rounded, context.l10n.t('nav_profile')),
                  ],
                ),
              ),
            ),

            // Center Learning button
            Positioned(
              bottom: 18,
              child: _buildCenterLearningButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _currentIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        splashColor: const Color(0xFF6C63FF).withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          const Color(0xFF6C63FF).withOpacity(0.15),
                          const Color(0xFF8B7FFF).withOpacity(0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: isSelected
                    ? Border.all(
                        color: const Color(0xFF6C63FF).withOpacity(0.2),
                        width: 1,
                      )
                    : null,
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected
                    ? const Color(0xFF6C63FF)
                    : const Color(0xFFB0B5C0),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF6C63FF)
                    : const Color(0xFFB0B5C0),
                letterSpacing: isSelected ? 0.3 : 0,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterLearningButton() {
    final isSelected = _currentIndex == 2;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isSelected
                      ? const [Color(0xFF6C63FF), Color(0xFF8B7FFF)]
                      : const [Color(0xFF6C63FF), Color(0xFF8B7FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.t('nav_learning'),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? const Color(0xFF6C63FF)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

