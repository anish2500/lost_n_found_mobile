import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/auth/data/datasources/auth_datasource.dart';
import 'package:lost_n_found/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:lost_n_found/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:lost_n_found/features/auth/data/models/auth_api_model.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/auth/domain/repositories/auth_repository.dart';

// Provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDataSource = ref.read(authLocalDatasourceProvider);
  final authRemoteDataSource = ref.read(authRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AuthRepository(
    authDatasource: authDataSource,
    authRemoteDataSource: authRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDataSource _authDataSource;
  final IAuthRemoteDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDataSource authDatasource,
    required IAuthRemoteDataSource authRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _authDataSource = authDatasource,
       _authRemoteDataSource = authRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final user = await _authDataSource.getCurrentUser();
      if (user != null) {
        final entity = user.toEntity();
        return Right(entity);
      }
      return Left(LocalDatabaseFailure(message: 'No user logged in'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.login(email, password);
        if (apiModel != null) {
          final entity = apiModel.toEntity();
          return Right(entity);
        }
        return const Left(ApiFailure(message: 'Invalid Credentials'));
      } on DioException catch (e) {
        return Left(
          ApiFailure(message: e.response?.data['message'] ?? 'Login Failed'),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final user = await _authDataSource.login(email, password);
        if (user != null) {
          final entity = user.toEntity();
          return Right(entity);
        }
        return const Left(
          LocalDatabaseFailure(message: 'Invalid email or password'),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authDataSource.logout();
      if (result) {
        return const Right(true);
      }
      return const Left(LocalDatabaseFailure(message: "failed to logout"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    if (await _networkInfo.isConnected) {
      //remote ma janey
      //entity lai model ma convert
      try {
        final apiModel = AuthApiModel.fromEntity(entity);
        await _authRemoteDataSource.register(apiModel);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Registration Failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        //check if email already exists
        final existingUser = await _authDataSource.getUserByEmail(entity.email);
        if (existingUser != null) {
          return const Left(
            LocalDatabaseFailure(message: 'Email already Registered'),
          );
        }

        final authModel = AuthHiveModel(
          fullName: entity.fullName,
          email: entity.email,
          phoneNumber: entity.phoneNumber,
          username: entity.username,
          password: entity.password,
          batchId: entity.batchId,
          profilePicture: entity.profilePicture,
        );
        await _authDataSource.register(authModel);

        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<bool> isEmailExists(String email) async {
    try {
      return await _authDataSource.isEmailExists(email);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUser(String authId) async {
    try {
      final result = await _authDataSource.deleteUser(authId);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity?>> getUserByEmail(String email) async {
    try {
      final user = await _authDataSource.getUserByEmail(email);
      return Right(user?.toEntity());
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity?>> getUserById(String authId) async {
    try {
      final user = await _authDataSource.getUserById(authId);
      return Right(user?.toEntity());
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateUser(AuthEntity entity) async {
    try {
      final model = AuthHiveModel.fromEntity(entity);
      final result = await _authDataSource.updateUser(model);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
