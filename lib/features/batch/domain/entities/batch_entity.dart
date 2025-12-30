import 'package:equatable/equatable.dart';

class BatchEntity extends Equatable {
  final String ?batchId;
  final String batchName;
  final String ?status; 

 const  BatchEntity({
    this.batchId,
    required this.batchName, 
    this.status  
  });
  @override
  // TODO: implement props
  List<Object?> get props =>[batchId, batchName, status];
}
