import 'package:lost_n_found/core/services/hive/hive_service.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/auth/data/datasources/auth_datasource.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);

  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthLocalDataSource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<AuthHiveModel> register(AuthHiveModel user) async {
    try {
      await _hiveService.registerUser(user);
      return user; // Return the user object as required by the new interface
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      if (user != null) {
        await _userSessionService.saveUserSession(
          userId: user.authId!,
          email: user.email,
          username: user.username,
          fullName: user.fullName,
          phoneNumber: user.phoneNumber,
          batchId: user.batchId,
          profileImage: user.profilePicture ?? '',
        );
      }
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthHiveModel?> getCurrentUser() async {
    try {
      final userId = _userSessionService.getUserId();
      if (userId != null) {
        return await _hiveService.getCurrentUser(userId);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _userSessionService.clearUserSession();
      return true;
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> isEmailExists(String email) async {
    try {
      return await _hiveService.isEmailExists(email);
    } catch (e) {
      throw Exception('Failed to check email: ${e.toString()}');
    }
  }

  @override
  Future<AuthHiveModel?> getUserById(String authId) async {
    try {
      return await _hiveService.getUserById(authId);
    } catch (e) {
      throw Exception('Failed to get user by ID: ${e.toString()}');
    }
  }

  @override
  Future<AuthHiveModel?> getUserByEmail(String email) async {
    try {
      return await _hiveService.getUserByEmail(email);
    } catch (e) {
      throw Exception('Failed to get user by email: ${e.toString()}');
    }
  }

  @override
  Future<bool> updateUser(AuthHiveModel user) async {
    try {
      await _hiveService.updateUser(user);
      return true;
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }

  @override
  Future<bool> deleteUser(String authId) async {
    try {
      await _hiveService.deleteUser(authId);
      return true;
    } catch (e) {
      throw Exception('Failed to delete user: ${e.toString()}');
    }
  }
}
