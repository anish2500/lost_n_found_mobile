import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecase.dart';
import 'package:lost_n_found/features/batch/data/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

//step 16 paxi ya auney

final getAllBatchUsecaseProvider = Provider<GetAllBatchUsecase>((ref) {
  return GetAllBatchUsecase(batchRepository: ref.read(batchRepositoryProvider));
});

class GetAllBatchUsecase implements UsecaseWithoutParams<List<BatchEntity>> {
  final IBatchRepository
  _batchRepository; //esma local database use bhairaxa so yo repo use gareko to make a clear choice

  GetAllBatchUsecase({required IBatchRepository batchRepository})
    : _batchRepository = batchRepository;
  @override
  Future<Either<Failure, List<BatchEntity>>> call() {
    return _batchRepository.getAllBatches();
  }
}
