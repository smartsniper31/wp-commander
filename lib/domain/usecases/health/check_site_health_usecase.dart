import '../../repositories/health_repository.dart';
import '../../entities/health_entity.dart';
import '../base_usecase.dart';

class CheckSiteHealthUseCase extends UseCase<HealthEntity, String> {
  final HealthRepository repository;

  CheckSiteHealthUseCase(this.repository);

  @override
  Future<UseCaseResult<HealthEntity>> execute(String siteId) async {
    if (siteId.isEmpty) {
      return UseCaseResult.error(
        UseCaseException(
          message: 'ID de site invalide',
          code: 'INVALID_SITE_ID',
        ),
      );
    }

    final result = await repository.getSiteHealth(siteId);

    return result.fold(
      (failure) => UseCaseResult.error(
        UseCaseException(message: failure.message, code: 'HEALTH_CHECK_FAILURE'),
      ),
      (health) => UseCaseResult.success(health),
    );
  }
}
