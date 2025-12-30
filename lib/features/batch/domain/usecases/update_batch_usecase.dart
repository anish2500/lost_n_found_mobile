import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecase.dart';
import 'package:lost_n_found/features/batch/data/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

class UpdateBatchUsecaseParams extends Equatable {
  final String batchId;
  final String batchName;
  final String? status;

  const UpdateBatchUsecaseParams({
    required this.batchId,
    required this.batchName,
    this.status,
  });
  @override
  List<Object?> get props => [batchId, batchName, status];
}

//usecase banauney

//step 17 paxi matra ya auney
final updateBatchUsecaseProvider = Provider<UpdateBatchUsecase>((ref) {
  return UpdateBatchUsecase(batchRepository: ref.read(batchRepositoryProvider));
});

class UpdateBatchUsecase
    implements UsecaseWithParams<bool, UpdateBatchUsecaseParams> {
  final IBatchRepository _batchRepository;

  UpdateBatchUsecase({required IBatchRepository batchRepository})
    : _batchRepository = batchRepository;
  @override
  Future<Either<Failure, bool>> call(UpdateBatchUsecaseParams params) {
    BatchEntity batchEntity = BatchEntity(
      batchName: params.batchName,
      batchId: params.batchId,
      status: params.status,
    );

    return _batchRepository.updateBatch(batchEntity);
  }
}
