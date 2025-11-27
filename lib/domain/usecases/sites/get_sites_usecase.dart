import 'package:either_dart/either.dart';
import 'package:wp_commander/core/errors/failures.dart';

import '../../entities/site_entity.dart';
import '../../repositories/site_repository.dart';

class GetSitesUseCase {
  final SiteRepository _repository;

  GetSitesUseCase(this._repository);

  Future<Either<Failure, List<SiteEntity>>> execute() async {
    return _repository.getSites();
  }
}
