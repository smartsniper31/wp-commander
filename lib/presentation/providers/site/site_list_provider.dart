import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/domain/usecases/sites/add_site_usecase.dart' hide addSiteUseCaseProvider;
import 'package:wp_commander/domain/usecases/sites/delete_site_usecase.dart' hide deleteSiteUseCaseProvider;
import 'package:wp_commander/domain/usecases/sites/get_sites_usecase.dart' hide getSitesUseCaseProvider;
import 'package:wp_commander/domain/usecases/sites/update_site_usecase.dart' hide updateSiteUseCaseProvider;
import 'package:wp_commander/presentation/providers/site/sites_state.dart';
import 'package:wp_commander/core/providers/usecase_providers.dart';
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
    try {
      final sites = await _getSitesUseCase.execute();
      state = SitesState.loaded(sites: sites);
    } catch (e) {
      state = SitesState.error(message: e.toString());
    }
  }

  Future<void> addSite(SiteEntity site) async {
    try {
      await _addSiteUseCase.execute(site as AddSiteParams);
      loadSites();
    } catch (e) {
      state = SitesState.error(message: e.toString());
    }
  }

  Future<void> updateSite(SiteEntity site) async {
    try {
      await _updateSiteUseCase.execute(site);
      loadSites();
    } catch (e) {
      state = SitesState.error(message: e.toString());
    }
  }

  Future<void> deleteSite(String siteId) async {
    try {
      await _deleteSiteUseCase.execute(siteId);
      loadSites();
    } catch (e) {
      state = SitesState.error(message: e.toString());
    }
  }
}

final sitesProvider = StateNotifierProvider<SitesNotifier, SitesState>((ref) {
  return SitesNotifier(
    getSitesUseCase: ref.watch(getSitesUseCaseProvider),
    addSiteUseCase: ref.watch(addSiteUseCaseProvider),
    updateSiteUseCase: ref.watch(updateSiteUseCaseProvider),
    deleteSiteUseCase: ref.watch(deleteSiteUseCaseProvider),
  );
});
