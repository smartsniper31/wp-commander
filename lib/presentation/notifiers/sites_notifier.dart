import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/domain/usecases/sites/add_site_usecase.dart';
import 'package:wp_commander/domain/usecases/sites/delete_site_usecase.dart';
import 'package:wp_commander/domain/usecases/sites/get_sites_usecase.dart';
import 'package:wp_commander/presentation/notifiers/sites_state.dart';

class SitesNotifier extends StateNotifier<SitesState> {
  final GetSitesUseCase _getSitesUseCase;
  final AddSiteUseCase _addSiteUseCase;
  final DeleteSiteUseCase _deleteSiteUseCase;

  SitesNotifier({
    required GetSitesUseCase getSitesUseCase,
    required AddSiteUseCase addSiteUseCase,
    required DeleteSiteUseCase deleteSiteUseCase,
  })  : _getSitesUseCase = getSitesUseCase,
        _addSiteUseCase = addSiteUseCase,
        _deleteSiteUseCase = deleteSiteUseCase,
        super(const SitesState.initial()) {
    fetchSites();
  }

  Future<void> fetchSites() async {
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
      (_) => fetchSites(), // Refresh the list after adding
    );
  }

  Future<void> deleteSite(String id) async {
    final result = await _deleteSiteUseCase.execute(id);
    result.fold(
      (failure) => state = SitesState.error(message: failure.message),
      (_) => fetchSites(), // Refresh the list after deleting
    );
  }

  void syncSite(String id) {}
}
