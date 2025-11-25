import 'package:wp_commander/core/errors/failures.dart';

import '../../repositories/site_repository.dart';
import '../../entities/site_entity.dart';
import '../base_usecase.dart';

class AddSiteUseCase extends UseCase<SiteEntity, AddSiteParams> {
  final SiteRepository repository;

  AddSiteUseCase(this.repository);

  @override
  Future<UseCaseResult<SiteEntity>> execute(AddSiteParams params) async {
    try {
      // Valider les paramètres d'entrée
      if (params.name.isEmpty || params.url.isEmpty || params.apiKey.isEmpty) {
        return UseCaseResult.error(
          UseCaseException(
            message: 'Tous les champs sont obligatoires',
            code: 'VALIDATION_ERROR',
          ),
        );
      }

      // Créer l'entité site
      final site = SiteEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: params.name,
        url: params.url,
        apiKey: params.apiKey,
        createdAt: DateTime.now(),
      );

      // Ajouter le site via le repository
      final addedSiteResult = await repository.addSite(site);

      return addedSiteResult.fold(
        (failure) {
          String message;
          String code;
          if (failure is ServerFailure) {
            message = 'Une erreur est survenue sur le serveur.';
            code = 'SERVER_FAILURE';
          } else if (failure is CacheFailure) {
            message = 'Une erreur de cache est survenue.';
            code = 'CACHE_FAILURE';
          } else {
            message = 'Une erreur inconnue est survenue.';
            code = 'UNKNOWN_FAILURE';
          }
          return UseCaseResult.error(
            UseCaseException(
              message: message,
              code: code,
            ),
          );
        },
        (addedSite) => UseCaseResult.success(addedSite),
      );
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
          message: e.toString(),
          code: 'UNKNOWN_ERROR',
        ),
      );
    }
  }
}

class AddSiteParams {
  final String name;
  final String url;
  final String apiKey;

  AddSiteParams({
    required this.name,
    required this.url,
    required this.apiKey,
  });
}
