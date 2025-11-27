import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/core/providers/repository_providers.dart';

import '../../entities/site_entity.dart';
import '../../repositories/site_repository.dart';

class UpdateSiteUseCase {
  final SiteRepository _repository;

  UpdateSiteUseCase(this._repository);

  Future<Either<Failure, void>> execute(SiteEntity site) async {
    return _repository.updateSite(site);
  }
}

final updateSiteUseCaseProvider = Provider<UpdateSiteUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return UpdateSiteUseCase(repository);
});
