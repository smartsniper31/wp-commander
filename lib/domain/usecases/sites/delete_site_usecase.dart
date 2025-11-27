import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/core/providers/repository_providers.dart';
import '../../repositories/site_repository.dart';

class DeleteSiteUseCase {
  final SiteRepository _repository;

  DeleteSiteUseCase(this._repository);

  Future<Either<Failure, void>> execute(String id) async {
    return _repository.deleteSite(id);
  }
}

final deleteSiteUseCaseProvider = Provider<DeleteSiteUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return DeleteSiteUseCase(repository);
});
