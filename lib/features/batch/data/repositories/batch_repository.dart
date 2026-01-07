import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_n_found/features/batch/data/datasources/local/batch_local_datasource.dart';
import 'package:lost_n_found/features/batch/data/datasources/remote/batch_remote_datasource.dart';
import 'package:lost_n_found/features/batch/data/models/batch_api_model.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

//step 14 paxi ya auney
//internet on
final batchRepositoryProvider = Provider<IBatchRepository>((ref) {
  final batchLocalDatasource = ref.read(batchLocalDataSourceProvider);
  final batchRemoteDataSource = ref.read(batchRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return BatchRepository(
    datasource: batchLocalDatasource,
    batchRemoteDataSource: batchRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class BatchRepository implements IBatchRepository {
  //yo class local datasource mathi dependent xa
  //Ibatch data source use garnu ko karan paxi internet hudako lagi
  final IBatchLocalDataSource _batchLocalDataSource;
  //remote
  final IBatchRemoteDataSource _batchRemoteDataSource;
  final NetworkInfo _networkInfo;

  BatchRepository({
    required IBatchLocalDataSource datasource,
    required IBatchRemoteDataSource batchRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _batchLocalDataSource = datasource,
       _batchRemoteDataSource = batchRemoteDataSource,
       _networkInfo = networkInfo;
  @override
  Future<Either<Failure, bool>> createBatch(BatchEntity entity) async {
    try {
      //entity lai model ma conversion garnu paryo
      final model = BatchHiveModel.fromEntity(entity);
      final result = await _batchLocalDataSource.createBatch(model);
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: 'Failed to create batch'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBatch(String batchId) {
    // TODO: implement deleteBatch
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> getAllBatches() async {
    //internet xa ki xaina
    if (await _networkInfo.isConnected) {
      try {
        //api model capture
        final apiModels = await _batchRemoteDataSource.getAllBatches();
        //convert to entity
        final result = BatchApiModel.toEntityList(apiModels);

        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? 'Failed to create batches',
          ),
        );
      }
    } else {
      try {
        final models = await _batchLocalDataSource.getAllBatches();
        final entities = BatchHiveModel.toEntityList(models); //conversion
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, BatchEntity>> getBatchById(String batchId) {
    // TODO: implement getBatchById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updateBatch(BatchEntity entity) {
    // TODO: implement updateBatch
    throw UnimplementedError();
  }
}
