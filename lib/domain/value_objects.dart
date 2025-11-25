import 'package:equatable/equatable.dart';

// Interface de base pour tous les Value Objects
abstract class ValueObject<T> extends Equatable {
  const ValueObject();

  T get value;
  String? get error;
  bool get isValid;
}
