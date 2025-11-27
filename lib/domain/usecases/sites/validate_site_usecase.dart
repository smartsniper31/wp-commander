import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/errors/exceptions.dart';
import 'package:wp_commander/core/providers/repository_providers.dart';

import '../../repositories/site_repository.dart';

class ValidateSiteUseCase {
  final SiteRepository _repository;

  ValidateSiteUseCase(this._repository);

  Future<bool> execute(ValidateSiteParams params) async {
    try {
      final result = await _repository.validateApiKey(
        url: params.url,
        apiKey: params.apiKey,
      );
      return result.fold((l) => false, (r) => r);
    } on RepositoryException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: 'Erreur lors de la validation du site');
    }
  }
}

final validateSiteUseCaseProvider = Provider<ValidateSiteUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return ValidateSiteUseCase(repository);
});

class ValidateSiteParams {
  final String url;
  final String apiKey;

  const ValidateSiteParams({
    required this.url,
    required this.apiKey,
  });
}
