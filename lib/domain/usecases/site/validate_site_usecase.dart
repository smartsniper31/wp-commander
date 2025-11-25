
import '../../repositories/site_repository.dart';
import '../base_usecase.dart';

class ValidateSiteUseCase extends UseCase<bool, ValidateSiteParams> {
  final SiteRepository repository;

  ValidateSiteUseCase(this.repository);

  @override
  Future<UseCaseResult<bool>> execute(ValidateSiteParams params) async {
    try {
      final isValid = await repository.validateApiKey(
        url: params.url,
        apiKey: params.apiKey,
      );
      
      return UseCaseResult.success(isValid);
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
          message: 'Erreur lors de la validation du site',
          code: 'VALIDATION_ERROR',
        ),
      );
    }
  }
}

class ValidateSiteParams {
  final String url;
  final String apiKey;

  const ValidateSiteParams({
    required this.url,
    required this.apiKey,
  });
}
