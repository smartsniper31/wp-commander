import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_providers.dart';
import '../../entities/site_entity.dart';
import '../../repositories/site_repository.dart';

class UpdateSiteUseCase {
  final SiteRepository _repository;

  UpdateSiteUseCase(this._repository);

  Future<SiteEntity> call(SiteEntity site) async {
    return await _repository.updateSite(site);
  }
}

final updateSiteUseCaseProvider = Provider<UpdateSiteUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return UpdateSiteUseCase(repository);
});
