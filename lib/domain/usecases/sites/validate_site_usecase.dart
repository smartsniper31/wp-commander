import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/core/providers/repository_providers.dart';

import '../../repositories/site_repository.dart';

class ValidateSiteUseCase {
  final SiteRepository _repository;

  ValidateSiteUseCase(this._repository);

  Future<Either<Failure, bool>> execute(ValidateSiteParams params) {
    return _repository.validateApiKey(
      url: params.url,
      apiKey: params.apiKey,
    );
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
