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

class AuthLocalDatasource implements IAuthDataSource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<bool> register(AuthHiveModel model) async {
    try {
      await _hiveService.registerUser(model);
      return true;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      if (user != null) {
        // Save user session
        await _userSessionService.saveUserSession(
          userId: user.authId!,
          email: user.email,
          username: user.email.split('@')[0], // Use email prefix as username
          fullName: user.fullName,
          phoneNumber: user.phone,
          batchId: user.batchId,
          profileImage: user.profilePicture ?? '',
        );
      }
      return user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthHiveModel?> getCurrentUser() async {
    try {
      final userId = _userSessionService.getUserId();
      if (userId != null) {
        return _hiveService.getCurrentUser(userId);
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
      return _hiveService.isEmailExists(email);
    } catch (e) {
      throw Exception('Failed to check email: ${e.toString()}');
    }
  }
}
