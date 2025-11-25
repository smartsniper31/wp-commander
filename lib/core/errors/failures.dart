import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  ServerFailure({required String message}) : super(message: message);
}

class CacheFailure extends Failure {
  CacheFailure({required String message}) : super(message: message);
}
