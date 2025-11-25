import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/errors/exceptions.dart';
import 'package:wp_commander/data/repositories/site_repository_impl.dart';
import 'package:wp_commander/core/providers/repository_providers.dart';
import '../../repositories/site_repository.dart';

class DeleteSiteUseCase {
  final SiteRepository _repository;

  DeleteSiteUseCase(this._repository);

  Future<void> execute(String id) async {
    try {
      await _repository.deleteSite(id);
    } on RepositoryException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: e.toString());
    }
  }
}

final deleteSiteUseCaseProvider = Provider<DeleteSiteUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return DeleteSiteUseCase(repository);
});
