import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failures.dart';
import '../../../core/providers/repository_providers.dart';
import '../../entities/site_entity.dart';
import '../../repositories/site_repository.dart';

class AddSiteUseCase {
  final SiteRepository _repository;

  AddSiteUseCase(this._repository);

  Future<Either<Failure, SiteEntity>> call(SiteEntity site) async {
    return await _repository.addSite(site);
  }
}

final addSiteUseCaseProvider = Provider<AddSiteUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return AddSiteUseCase(repository);
});
