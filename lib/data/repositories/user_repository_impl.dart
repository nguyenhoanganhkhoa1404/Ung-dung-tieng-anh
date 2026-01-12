import '../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/firebase_firestore_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestoreDataSource firestoreDataSource;
  
  UserRepositoryImpl({required this.firestoreDataSource});
  
  @override
  Future<UserEntity> getUserById(String userId) async {
    try {
      final doc = await firestoreDataSource.getDocument(
        AppConstants.usersCollection,
        userId,
      );
      
      if (!doc.exists) {
        throw Exception('Người dùng không tồn tại');
      }
      
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Lấy thông tin người dùng thất bại: $e');
    }
  }
  
  @override
  Future<void> updateUser(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await firestoreDataSource.updateDocument(
        AppConstants.usersCollection,
        user.id,
        userModel.toFirestore(),
      );
    } catch (e) {
      throw Exception('Cập nhật người dùng thất bại: $e');
    }
  }
  
  @override
  Future<void> updateUserLevel(String userId, String level) async {
    try {
      await firestoreDataSource.updateDocument(
        AppConstants.usersCollection,
        userId,
        {'level': level},
      );
    } catch (e) {
      throw Exception('Cập nhật cấp độ thất bại: $e');
    }
  }
  
  @override
  Future<void> addXP(String userId, int xp) async {
    try {
      final user = await getUserById(userId);
      final newXP = user.xp + xp;
      
      await firestoreDataSource.updateDocument(
        AppConstants.usersCollection,
        userId,
        {'xp': newXP},
      );
    } catch (e) {
      throw Exception('Thêm XP thất bại: $e');
    }
  }
  
  @override
  Future<void> updateStreak(String userId, int streakDays) async {
    try {
      await firestoreDataSource.updateDocument(
        AppConstants.usersCollection,
        userId,
        {'streakDays': streakDays},
      );
    } catch (e) {
      throw Exception('Cập nhật streak thất bại: $e');
    }
  }
  
  @override
  Future<void> updateLastStudyDate(String userId, DateTime date) async {
    try {
      await firestoreDataSource.updateDocument(
        AppConstants.usersCollection,
        userId,
        {'lastStudyDate': date},
      );
    } catch (e) {
      throw Exception('Cập nhật ngày học thất bại: $e');
    }
  }
}

