import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/domain/usecases/sites/add_site_usecase.dart';
import 'package:wp_commander/domain/usecases/sites/delete_site_usecase.dart' hide deleteSiteUseCaseProvider;
import 'package:wp_commander/domain/usecases/sites/get_sites_usecase.dart';
import 'package:wp_commander/domain/usecases/sites/update_site_usecase.dart' hide updateSiteUseCaseProvider;
import 'package:wp_commander/presentation/providers/site/sites_state.dart';
import 'package:wp_commander/core/providers/usecase_providers.dart' hide addSiteUseCaseProvider;
import 'package:wp_commander/domain/entities/site_entity.dart';

class SitesNotifier extends StateNotifier<SitesState> {
  final GetSitesUseCase _getSitesUseCase;
  final AddSiteUseCase _addSiteUseCase;
  final UpdateSiteUseCase _updateSiteUseCase;
  final DeleteSiteUseCase _deleteSiteUseCase;

  SitesNotifier({
    required GetSitesUseCase getSitesUseCase,
    required AddSiteUseCase addSiteUseCase,
    required UpdateSiteUseCase updateSiteUseCase,
    required DeleteSiteUseCase deleteSiteUseCase,
  })  : _getSitesUseCase = getSitesUseCase,
        _addSiteUseCase = addSiteUseCase,
        _updateSiteUseCase = updateSiteUseCase,
        _deleteSiteUseCase = deleteSiteUseCase,
        super(const SitesState.initial());

  Future<void> loadSites() async {
    state = const SitesState.loading();
    final result = await _getSitesUseCase.execute();
    result.fold(
      (failure) => state = SitesState.error(message: failure.message),
      (sites) => state = SitesState.loaded(sites: sites),
    );
  }

  Future<void> addSite(AddSiteParams params) async {
    final result = await _addSiteUseCase.execute(params);
    result.fold(
      (failure) => state = SitesState.error(message: failure.message),
      (_) => loadSites(),
    );
  }

  Future<void> updateSite(SiteEntity site) async {
    final result = await _updateSiteUseCase.execute(site);
    result.fold(
      (failure) => state = SitesState.error(message: failure.message),
      (_) => loadSites(),
    );
  }

  Future<void> deleteSite(String siteId) async {
    final result = await _deleteSiteUseCase.execute(siteId);
    result.fold(
      (failure) => state = SitesState.error(message: failure.message),
      (_) => loadSites(),
    );
  }
}

final siteListProvider = StateNotifierProvider<SitesNotifier, SitesState>((ref) {
  return SitesNotifier(
    getSitesUseCase: ref.watch(getSitesUseCaseProvider),
    addSiteUseCase: ref.watch(addSiteUseCaseProvider),
    updateSiteUseCase: ref.watch(updateSiteUseCaseProvider),
    deleteSiteUseCase: ref.watch(deleteSiteUseCaseProvider),
  );
});
