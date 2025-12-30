import 'package:dartz/dartz.dart';
import 'package:lost_n_found/core/error/failures.dart';

import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';


abstract interface class IBatchRepository {
  Future<Either<Failure, List<BatchEntity>>> getAllBatches();//parameterless methods 
  Future<Either<Failure, BatchEntity>> getBatchById(String batchId);//parameterized methods 
  Future<Either<Failure, bool>> createBatch(BatchEntity entity);
  Future<Either<Failure, bool>> updateBatch(BatchEntity entity);
  Future<Either<Failure, bool>> deleteBatch(String batchId);
}


// return type can be any type and parameter pani j ni hunxa sakxa 


//Generic class can handle any types of functions 
// 