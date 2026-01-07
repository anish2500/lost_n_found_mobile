import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthDataSource {
  Future<bool> register(AuthHiveModel model);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();

  //email exists
  Future<bool> isEmailExists(String email);
}