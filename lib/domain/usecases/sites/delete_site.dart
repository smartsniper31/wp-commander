import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_providers.dart';
import '../../repositories/site_repository.dart';

class DeleteSiteUseCase {
  final SiteRepository _repository;

  DeleteSiteUseCase(this._repository);

  Future<void> call(String id) async {
    await _repository.deleteSite(id);
  }
}

final deleteSiteUseCaseProvider = Provider<DeleteSiteUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return DeleteSiteUseCase(repository);
});
