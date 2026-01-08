import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_all_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:lost_n_found/features/batch/presentation/state/batch_state.dart';

//after step 18 ya auney pheri
final batchViewModelProvider = NotifierProvider<BatchViewModel, BatchState>(() {
  return BatchViewModel();
});

class BatchViewModel extends Notifier<BatchState> {
  late final GetAllBatchUsecase _getAllBatchUsecase;
  late final UpdateBatchUsecase _updateBatchUsecase;
  late final CreateBatchUsecase _createBatchUsecase;
  @override
  BatchState build() {
    //initialization garnu paryo
    //this is also after step 18
    _getAllBatchUsecase = ref.read(getAllBatchUsecaseProvider);
    _updateBatchUsecase = ref.read(updateBatchUsecaseProvider);
    _createBatchUsecase = ref.read(createBatchUsecaseProvider);
    return BatchState(); //inital state
  }

  Future<void> getAllBatches() async {
    state = state.copyWith(status: BatchStatus.loading);
    final result = await _getAllBatchUsecase();

    result.fold(
      (left) {
        state = state.copyWith(
          status: BatchStatus.error,
          errorMessage: left.message,
        );
      },
      (batches) {
        state = state.copyWith(status: BatchStatus.loaded, batches: batches);
      },
    );
  }

  // future ma create batch case garau
  Future<void> createBatch(String batchName) async {
    //progress bar suru ma ghumaunu paryo using copywith
    state = state.copyWith(status: BatchStatus.loading);

    final result = await _createBatchUsecase(
      CreateBatchUsecaseParams(batchName: batchName),
    );
    result.fold(
      (left) {
        state = state.copyWith(
          status: BatchStatus.error,
          errorMessage: left.message,
        );
      },
      (right) {
        state = state.copyWith(status: BatchStatus.loaded);
      },
    );
  }
}
