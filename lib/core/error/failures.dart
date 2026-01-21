import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

//Local Database failure
class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure({
    String message = 'Local Database operation failed.',
  }) : super(message);
}

//Api database failure
class ApiFailure extends Failure {
  final int? statusCode;

  const ApiFailure({String message = "API Failure", this.statusCode})
    : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = "No Internet Connection"})
    : super(message);
}
