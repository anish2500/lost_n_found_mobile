import 'package:equatable/equatable.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

//enum use garda eutai variable ma multiple value store garna payo 
enum BatchStatus { initial, loading, loaded, error, created, updated, deleted }
//esma app suruma load huda initial state ma hunxa  

class BatchState extends Equatable {
  final BatchStatus status;
  final List<BatchEntity> batches;
  final String? errorMessage;

  const BatchState({
    this.status = BatchStatus.initial, 
    this.batches = const [], 
    this.errorMessage, 
  });

  //copywith function 
  BatchState copyWith({
    BatchStatus ? status, 
    List<BatchEntity> ? batches, 
    String? errorMessage, 
  }){
    return BatchState(
      status : status ?? this.status,
      batches : batches ?? this.batches, 
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, batches, errorMessage];
}
