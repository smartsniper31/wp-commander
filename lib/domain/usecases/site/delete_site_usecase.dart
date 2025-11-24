
import '../../repositories/site_repository.dart';
import '../base_usecase.dart';

class DeleteSiteUseCase extends UseCase<void, String> {
  final SiteRepository repository;

  DeleteSiteUseCase(this.repository);

  @override
  Future<UseCaseResult<void>> execute(String id) async {
    // TODO: Implémenter
    throw UnimplementedError();
  }
}
