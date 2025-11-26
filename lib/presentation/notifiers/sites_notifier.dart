import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/domain/usecases/sites/add_site_usecase.dart';
import 'package:wp_commander/domain/usecases/sites/delete_site_usecase.dart';
import 'package:wp_commander/domain/usecases/sites/get_sites_usecase.dart';
import 'package:wp_commander/domain/usecases/sites/update_site_usecase.dart';
import 'package:wp_commander/presentation/notifiers/sites_state.dart';

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

  Future<void> getSites() async {
    state = const SitesState.loading();
    final result = await _getSitesUseCase.execute(null);
    state = result.when(
      success: (sites) => SitesState.loaded(sites: sites),
      error: (exception) => SitesState.error(message: exception.message),
    );
  }

  Future<void> addSite(Site site) async {
    state = const SitesState.loading();
    final result = await _addSiteUseCase.execute(site);
    result.when(
      success: (_) => getSites(),
      error: (exception) => state = SitesState.error(message: exception.message),
    );
  }

  Future<void> updateSite(Site site) async {
    final result = await _updateSiteUseCase.execute(site);
    result.when(
      success: (_) => getSites(),
      error: (exception) => state = SitesState.error(message: exception.message),
    );
  }

  Future<void> deleteSite(String id) async {
    final result = await _deleteSiteUseCase.execute(id);
    result.when(
      success: (_) => getSites(),
      error: (exception) => state = SitesState.error(message: exception.message),
    );
  }
}
