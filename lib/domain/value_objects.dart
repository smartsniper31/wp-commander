// Interface de base pour tous les Value Objects
abstract class ValueObject<T> {
  T get value;
  String? get error;
  bool get isValid;
}
