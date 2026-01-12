import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/onboarding/onboarding_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/main/main_page.dart';
import '../../presentation/pages/placement_test/placement_test_page.dart';
import '../../presentation/pages/vocabulary/vocabulary_page.dart';
import '../../presentation/pages/grammar/grammar_page.dart';
import '../../presentation/pages/listening/listening_page.dart';
import '../../presentation/pages/speaking/speaking_page.dart';
import '../../presentation/pages/reading/reading_page.dart';
import '../../presentation/pages/writing/writing_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/statistics/statistics_page.dart';
import '../../presentation/pages/settings/settings_page.dart';

class AppRouter {
  // Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String placementTest = '/placement-test';
  static const String vocabulary = '/vocabulary';
  static const String grammar = '/grammar';
  static const String listening = '/listening';
  static const String speaking = '/speaking';
  static const String reading = '/reading';
  static const String writing = '/writing';
  static const String profile = '/profile';
  static const String statistics = '/statistics';
  static const String settings = '/settings';
  
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
        
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
        
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
        
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
        
      case home:
        // IMPORTANT:
        // Home route should land on MainPage so BottomNavigationBar is visible.
        return MaterialPageRoute(builder: (_) => const MainPage());
        
      case placementTest:
        return MaterialPageRoute(builder: (_) => const PlacementTestPage());
        
      case vocabulary:
        final userId1 = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
        return MaterialPageRoute(builder: (_) => VocabularyPage(userId: userId1));
        
      case grammar:
        final userId2 = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
        return MaterialPageRoute(builder: (_) => GrammarPage(userId: userId2));
        
      case listening:
        final userId3 = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
        return MaterialPageRoute(builder: (_) => ListeningPage(userId: userId3));
        
      case speaking:
        final userId4 = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
        return MaterialPageRoute(builder: (_) => SpeakingPage(userId: userId4));
        
      case reading:
        final userId5 = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
        return MaterialPageRoute(builder: (_) => ReadingPage(userId: userId5));
        
      case writing:
        final userId6 = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
        return MaterialPageRoute(builder: (_) => WritingPage(userId: userId6));
        
      case profile:
        final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
        return MaterialPageRoute(builder: (_) => ProfilePage(userId: userId));
        
      case statistics:
        return MaterialPageRoute(builder: (_) => const StatisticsPage());
        
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${routeSettings.name} not found'),
            ),
          ),
        );
    }
  }
}

