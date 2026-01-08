import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/api/api_client.dart';
import 'package:lost_n_found/core/api/api_endpoints.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/auth/data/datasources/auth_datasource.dart';
import 'package:lost_n_found/features/auth/data/models/auth_api_model.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';

//create provider
final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  //api client

  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.students,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);
      return registeredUser;
    }

    return user; 
  }
}
