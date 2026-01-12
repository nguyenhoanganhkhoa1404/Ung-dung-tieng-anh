import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'app/app.dart';
import 'app/di.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with error handling
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('✅ Firebase initialized successfully');
    } else {
      print('ℹ️ Firebase already initialized');
    }

    // Web: ensure auth session is persisted across refresh/relaunch
    if (kIsWeb) {
      try {
        await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
        print('✅ FirebaseAuth persistence set to LOCAL (web)');
      } catch (e) {
        print('⚠️ FirebaseAuth persistence not set (web): $e');
      }
    }
  } catch (e) {
    print('⚠️ Firebase initialization error (non-critical): $e');
    // Continue anyway - app can still work without Firebase for development
  }
  
  // Setup Dependency Injection
  try {
    await setupDependencyInjection();
    print('✅ Dependency Injection setup complete');
  } catch (e) {
    print('❌ DI Setup Error: $e');
  }
  
  // Run the app
  runApp(const MyApp());
}
