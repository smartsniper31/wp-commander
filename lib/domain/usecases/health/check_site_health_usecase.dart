
import '../../repositories/health_repository.dart';
import '../../entities/health_entity.dart';
import '../base_usecase.dart';

class CheckSiteHealthUseCase extends UseCase<HealthEntity, String> {
  final HealthRepository repository;

  CheckSiteHealthUseCase(this.repository);

  @override
  Future<UseCaseResult<HealthEntity>> execute(String siteId) async {
    try {
      if (siteId.isEmpty) {
        return UseCaseResult.error(
          UseCaseException(
            message: 'ID de site invalide',
            code: 'INVALID_SITE_ID',
          ),
        );
      }

      final health = await repository.getSiteHealth(siteId);
      
      return UseCaseResult.success(health);
    } on RepositoryException catch (e) {
      return UseCaseResult.error(
        UseCaseException(
          message: e.message,
          code: e.code,
        ),
      );
    } catch (e) {
      return UseCaseResult.error(
        UseCaseException(
          message: 'Erreur lors de la vérification de la santé du site',
          code: 'HEALTH_CHECK_ERROR',
        ),
      );
    }
  }
}
