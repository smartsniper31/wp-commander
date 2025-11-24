import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_providers.dart';
import '../../entities/site_entity.dart';
import '../../repositories/site_repository.dart';

class GetSitesUseCase {
  final SiteRepository _repository;

  GetSitesUseCase(this._repository);

  Future<List<SiteEntity>> call() async {
    return await _repository.getSites();
  }
}

final getSitesUseCaseProvider = Provider<GetSitesUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return GetSitesUseCase(repository);
});
