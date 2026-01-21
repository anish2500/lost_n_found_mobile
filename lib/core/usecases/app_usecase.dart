import 'package:dartz/dartz.dart';
import 'package:lost_n_found/core/error/failures.dart';



//two usecases are made here with params and without params 
abstract interface class UsecaseWithParams<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}// return type and paramter is passed 


abstract interface class UsecaseWithoutParams<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}