import 'package:wp_commander/domain/value_objects.dart';

class ApiKeyVO extends ValueObject<String> {
  @override
  final String value;

  @override
  final String? error;

  const ApiKeyVO._(this.value, {this.error});

  factory ApiKeyVO.create(String input) {
    final trimmedInput = input.trim();
    
    if (trimmedInput.isEmpty) {
      return ApiKeyVO._(trimmedInput, error: 'La clé API est obligatoire');
    }

    if (trimmedInput.length < 10) {
      return ApiKeyVO._(trimmedInput, error: 'Clé API trop courte');
    }

    if (trimmedInput.length > 255) {
      return ApiKeyVO._(trimmedInput, error: 'Clé API trop longue');
    }

    final apiKeyPattern = RegExp(r'^[a-zA-Z0-9_\\-!@#\$%^&*()+={}|:;"<>,.?/\\\[\\\]~]+\$');
    
    if (!apiKeyPattern.hasMatch(trimmedInput)) {
      return ApiKeyVO._(trimmedInput, error: 'Clé API contient des caractères invalides');
    }

    return ApiKeyVO._(trimmedInput);
  }

  @override
  bool get isValid => error == null;

  String get maskedValue {
    if (value.length > 8) {
      return '\${value.substring(0, 4)}...\${value.substring(value.length - 4)}';
    }
    if (value.isEmpty) {
        return '';
    }
    return '...\${value.substring(value.length - 4)}';
  }

  @override
  List<Object?> get props => [value, error];
}
