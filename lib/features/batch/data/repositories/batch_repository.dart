import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_n_found/features/batch/data/datasources/local/batch_local_datasource.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

//step 14 paxi ya auney
//internet on
final batchRepositoryProvider = Provider<IBatchRepository>((ref) {
  return BatchRepository(datasource: ref.read(batchLocalDataSourceProvider));
});

class BatchRepository implements IBatchRepository {
  //yo class local datasource mathi dependent xa
  //Ibatch data source use garnu ko karan paxi internet hudako lagi
  final IBatchDataSource _datasource;

  BatchRepository({required IBatchDataSource datasource})
    : _datasource = datasource;
  @override
  Future<Either<Failure, bool>> createBatch(BatchEntity entity) async {
    try {
      //entity lai model ma conversion garnu paryo
      final model = BatchHiveModel.fromEntity(entity);
      final result = await _datasource.createBatch(model);
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
    try {
      final models = await _datasource.getAllBatches();
      final entities = BatchHiveModel.toEntityList(models); //conversion
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
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
