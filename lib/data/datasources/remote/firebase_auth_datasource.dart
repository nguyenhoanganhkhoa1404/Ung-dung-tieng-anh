import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthDataSource {
  Future<User> loginWithEmail(String email, String password);
  Future<User> registerWithEmail(String email, String password);
  Future<User> loginWithGoogle();
  Future<void> logout();
  User? getCurrentUser();
  Stream<User?> get authStateChanges;
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  
  FirebaseAuthDataSourceImpl(this._firebaseAuth);
  
  @override
  Future<User> loginWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw Exception('Đăng nhập thất bại');
      }
      
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  @override
  Future<User> registerWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw Exception('Đăng ký thất bại');
      }
      
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  @override
  Future<User> loginWithGoogle() async {
    // Implementation for Google Sign In
    throw UnimplementedError('Google Sign In chưa được triển khai');
  }
  
  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
  
  @override
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
  
  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('Email không tồn tại');
      case 'wrong-password':
        return Exception('Mật khẩu không đúng');
      case 'email-already-in-use':
        return Exception('Email đã được sử dụng');
      case 'weak-password':
        return Exception('Mật khẩu quá yếu');
      case 'invalid-email':
        return Exception('Email không hợp lệ');
      default:
        return Exception(e.message ?? 'Đã xảy ra lỗi');
    }
  }
}

