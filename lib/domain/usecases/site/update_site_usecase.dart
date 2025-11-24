
import '../../repositories/site_repository.dart';
import '../../entities/site_entity.dart';
import '../base_usecase.dart';

class UpdateSiteUseCase extends UseCase<SiteEntity, SiteEntity> {
  final SiteRepository repository;

  UpdateSiteUseCase(this.repository);

  @override
  Future<UseCaseResult<SiteEntity>> execute(SiteEntity site) async {
    // TODO: Implémenter
    throw UnimplementedError();
  }
}
