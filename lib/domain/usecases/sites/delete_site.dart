import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failures.dart';
import '../../../core/providers/repository_providers.dart';
import '../../repositories/site_repository.dart';

class DeleteSiteUseCase {
  final SiteRepository _repository;

  DeleteSiteUseCase(this._repository);

  Future<Either<Failure, void>> call(String id) async {
    return await _repository.deleteSite(id);
  }
}

final deleteSiteUseCaseProvider = Provider<DeleteSiteUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return DeleteSiteUseCase(repository);
});
