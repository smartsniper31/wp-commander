import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/errors/exceptions.dart';
import 'package:wp_commander/data/repositories/site_repository_impl.dart';
import 'package:wp_commander/core/providers/repository_providers.dart';

import '../../entities/site_entity.dart';
import '../../repositories/site_repository.dart';

class AddSiteUseCase {
  final SiteRepository _repository;

  AddSiteUseCase(this._repository);

  Future<SiteEntity> execute(AddSiteParams params) async {
    if (params.name.isEmpty || params.url.isEmpty || params.apiKey.isEmpty) {
      throw UseCaseException(message: 'Tous les champs sont obligatoires');
    }

    final site = SiteEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: params.name,
      url: params.url,
      apiKey: params.apiKey,
      createdAt: DateTime.now(),
    );

    try {
      return await _repository.addSite(site);
    } on RepositoryException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: e.toString());
    }
  }
}

final addSiteUseCaseProvider = Provider<AddSiteUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return AddSiteUseCase(repository);
});

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
