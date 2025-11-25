import 'package:wp_commander/domain/value_objects.dart';

class SiteNameVO extends ValueObject<String> {
  @override
  final String value;

  @override
  final String? error;

  const SiteNameVO._(this.value, {this.error});

  factory SiteNameVO.create(String input) {
    final trimmedInput = input.trim();
    
    if (trimmedInput.isEmpty) {
      return SiteNameVO._(trimmedInput, error: 'Le nom du site est obligatoire');
    }

    if (trimmedInput.length > 50) {
      return SiteNameVO._(trimmedInput, error: 'Nom de site trop long');
    }

    return SiteNameVO._(trimmedInput);
  }

  @override
  bool get isValid => error == null;

  @override
  List<Object?> get props => [value, error];
}
