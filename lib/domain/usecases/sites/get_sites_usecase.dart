import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/core/providers/repository_providers.dart';

import '../../entities/site_entity.dart';
import '../../repositories/site_repository.dart';

class GetSitesUseCase {
  final SiteRepository _repository;

  GetSitesUseCase(this._repository);

  Future<Either<Failure, List<SiteEntity>>> execute() async {
    return _repository.getSites();
  }
}

final getSitesUseCaseProvider = Provider<GetSitesUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return GetSitesUseCase(repository);
});
