
import '../value_objects/url_vo.dart';
import '../value_objects/api_key_vo.dart';
import '../value_objects/site_name_vo.dart';

class ValidationService {
  // Valider un site complet
  static SiteValidationResult validateSite({
    required String name,
    required String url,
    required String apiKey,
  }) {
    final nameVO = SiteNameVO.create(name);
    final urlVO = UrlVO.create(url);
    final apiKeyVO = ApiKeyVO.create(apiKey);

    final errors = <String>[];
    if (!nameVO.isValid) errors.add(nameVO.error!);
    if (!urlVO.isValid) errors.add(urlVO.error!);
    if (!apiKeyVO.isValid) errors.add(apiKeyVO.error!);

    return SiteValidationResult(
      name: nameVO,
      url: urlVO,
      apiKey: apiKeyVO,
      errors: errors,
      isValid: errors.isEmpty,
    );
  }

  // Valider une URL WordPress
  static bool isValidWordPressUrl(String url) {
    final urlVO = UrlVO.create(url);
    return urlVO.isValid;
  }

  // Valider une clé API
  static bool isValidApiKey(String apiKey) {
    final apiKeyVO = ApiKeyVO.create(apiKey);
    return apiKeyVO.isValid;
  }

  // Normaliser une URL
  static String normalizeUrl(String url) {
    final urlVO = UrlVO.create(url);
    return urlVO.value;
  }

  // Vérifier la force d'une clé API
  static ApiKeyStrength checkApiKeyStrength(String apiKey) {
    if (apiKey.length < 16) return ApiKeyStrength.weak;
    if (apiKey.length < 32) return ApiKeyStrength.medium;

    // Vérifier la complexité
    final hasUpper = RegExp(r'[A-Z]').hasMatch(apiKey);
    final hasLower = RegExp(r'[a-z]').hasMatch(apiKey);
    final hasNumbers = RegExp(r'[0-9]').hasMatch(apiKey);
    final hasSymbols = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(apiKey);

    final complexityScore = [hasUpper, hasLower, hasNumbers, hasSymbols]
        .where((element) => element)
        .length;

    if (complexityScore >= 3) return ApiKeyStrength.strong;
    if (complexityScore >= 2) return ApiKeyStrength.medium;
    return ApiKeyStrength.weak;
  }
}

class SiteValidationResult {
  final SiteNameVO name;
  final UrlVO url;
  final ApiKeyVO apiKey;
  final List<String> errors;
  final bool isValid;

  const SiteValidationResult({
    required this.name,
    required this.url,
    required this.apiKey,
    required this.errors,
    required this.isValid,
  });

  String? get firstError => errors.isNotEmpty ? errors.first : null;
}

enum ApiKeyStrength {
  weak('Faible', '🔴'),
  medium('Moyenne', '🟡'),
  strong('Forte', '🟢');

  final String label;
  final String emoji;

  const ApiKeyStrength(this.label, this.emoji);
}
