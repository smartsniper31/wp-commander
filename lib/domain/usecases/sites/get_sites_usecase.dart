import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/errors/exceptions.dart';
import 'package:wp_commander/data/repositories/site_repository_impl.dart';
import 'package:wp_commander/core/providers/repository_providers.dart';

import '../../entities/site_entity.dart';
import '../../repositories/site_repository.dart';

class GetSitesUseCase {
  final SiteRepository _repository;

  GetSitesUseCase(this._repository);

  Future<List<SiteEntity>> execute() async {
    try {
      return await _repository.getSites();
    } on RepositoryException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: e.toString());
    }
  }
}

final getSitesUseCaseProvider = Provider<GetSitesUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return GetSitesUseCase(repository);
});
