import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/errors/exceptions.dart';
import 'package:wp_commander/data/repositories/site_repository_impl.dart';
import 'package:wp_commander/core/providers/repository_providers.dart';

import '../../entities/site_entity.dart';
import '../../repositories/site_repository.dart';

class UpdateSiteUseCase {
  final SiteRepository _repository;

  UpdateSiteUseCase(this._repository);

  Future<void> execute(SiteEntity site) async {
    try {
      await _repository.updateSite(site);
    } on RepositoryException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: e.toString());
    }
  }
}

final updateSiteUseCaseProvider = Provider<UpdateSiteUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return UpdateSiteUseCase(repository);
});
