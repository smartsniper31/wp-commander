import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [];

  factory Failure.server() => ServerFailure();
  factory Failure.cache() => CacheFailure();
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
