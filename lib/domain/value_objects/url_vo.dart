import 'package:wp_commander/domain/value_objects.dart';

class UrlVO extends ValueObject<String> {
  @override
  final String value;

  @override
  final String? error;

  const UrlVO._(this.value, {this.error});

  factory UrlVO.create(String input) {
    final trimmedInput = input.trim();
    
    if (trimmedInput.isEmpty) {
      return UrlVO._(trimmedInput, error: 'L\'URL est obligatoire');
    }

    final urlPattern = RegExp(
        r'^(https?://)?([\da-z.-]+)\.([a-z.]{2,6})([/\w .-]*)*/?$');
    
    if (!urlPattern.hasMatch(trimmedInput)) {
      return UrlVO._(trimmedInput, error: 'Format d\'URL invalide');
    }

    return UrlVO._(trimmedInput);
  }

  @override
  bool get isValid => error == null;

  String get cleanUrl {
    var url = value.replaceAll(RegExp(r'^https?://'), '');
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }

  @override
  List<Object?> get props => [value, error];
}
