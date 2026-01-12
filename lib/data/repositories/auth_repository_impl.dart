import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/firebase_auth_datasource.dart';
import '../datasources/local/shared_prefs_helper.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource authDataSource;
  final SharedPrefsHelper sharedPrefsHelper;
  
  AuthRepositoryImpl({
    required this.authDataSource,
    required this.sharedPrefsHelper,
  });
  
  @override
  Future<UserEntity> loginWithEmail(String email, String password) async {
    try {
      final firebaseUser = await authDataSource.loginWithEmail(email, password);
      
      // Get user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      
      // If user document doesn't exist (or schema migrated), create a minimal one.
      if (!userDoc.exists) {
        final now = DateTime.now();
        final displayName =
            firebaseUser.displayName ?? email.split('@').first;
        final user = UserModel(
          id: firebaseUser.uid,
          email: email,
          displayName: displayName,
          photoUrl: firebaseUser.photoURL,
          level: 'A1',
          xp: 0,
          currentLevel: 1,
          streakDays: 0,
          createdAt: now,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .set(user.toFirestore(), SetOptions(merge: true));
        return user;
      }
      
      final user = UserModel.fromFirestore(userDoc);
      
      // Save to local storage
      await sharedPrefsHelper.setUserId(user.id);
      await sharedPrefsHelper.setUserLevel(user.level);
      
      return user;
    } catch (e) {
      throw Exception('Đăng nhập thất bại: $e');
    }
  }
  
  @override
  Future<UserEntity> registerWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final firebaseUser = await authDataSource.registerWithEmail(email, password);
      
      // Create user document in Firestore
      final user = UserModel(
        id: firebaseUser.uid,
        email: email,
        displayName: displayName,
        level: 'A1',
        xp: 0,
        currentLevel: 1,
        streakDays: 0,
        createdAt: DateTime.now(),
      );
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set(user.toFirestore(), SetOptions(merge: true));

      // Create public leaderboard entry (không lưu email)
      await FirebaseFirestore.instance
          .collection('leaderboard')
          .doc(user.id)
          .set({
        'user_id': user.id,
        'name': displayName,
        'total_xp': 0,
        'current_streak': 0,
        'total_learning_minutes': 0,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      // Save to local storage
      await sharedPrefsHelper.setUserId(user.id);
      await sharedPrefsHelper.setUserLevel(user.level);
      
      return user;
    } catch (e) {
      throw Exception('Đăng ký thất bại: $e');
    }
  }
  
  @override
  Future<UserEntity> loginWithGoogle() async {
    throw UnimplementedError('Đăng nhập Google chưa được triển khai');
  }
  
  @override
  Future<void> logout() async {
    await authDataSource.logout();
    await sharedPrefsHelper.clearAll();
  }
  
  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = authDataSource.getCurrentUser();
    
    if (firebaseUser == null) {
      return null;
    }
    
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      
      if (!userDoc.exists) {
        // Create a minimal doc so auth can persist cleanly across app restarts.
        final now = DateTime.now();
        final email = firebaseUser.email ?? '';
        final displayName =
            firebaseUser.displayName ?? (email.isNotEmpty ? email.split('@').first : 'User');
        final user = UserModel(
          id: firebaseUser.uid,
          email: email,
          displayName: displayName,
          photoUrl: firebaseUser.photoURL,
          level: 'A1',
          xp: 0,
          currentLevel: 1,
          streakDays: 0,
          createdAt: now,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .set(user.toFirestore(), SetOptions(merge: true));
        return user;
      }
      
      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<bool> isLoggedIn() async {
    return authDataSource.getCurrentUser() != null;
  }
  
  @override
  Future<void> resetPassword(String email) async {
    // Implementation would go here
    throw UnimplementedError('Reset password chưa được triển khai');
  }
}

