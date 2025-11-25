import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/domain/usecases/sites/add_site.dart';
import 'package:wp_commander/domain/usecases/sites/delete_site.dart';
import 'package:wp_commander/domain/usecases/sites/get_sites.dart';

part 'sites_notifier.g.dart';

@Riverpod(keepAlive: true)
class SitesNotifier extends _$SitesNotifier {
  @override
  Future<List<SiteEntity>> build() async {
    // The build method now fetches the initial list of sites.
    // It will be re-run automatically when the provider is invalidated.
    final result = await ref.watch(getSitesUseCaseProvider).call();
    return result.fold(
      (failure) => throw failure,
      (sites) => sites,
    );
  }

  Future<void> addSite(SiteEntity site) async {
    // 1. Get the use case from the provider.
    final addSiteUseCase = ref.read(addSiteUseCaseProvider);

    // 2. Set the state to loading to show a spinner in the UI.
    state = const AsyncValue.loading();

    // 3. Call the use case and update the state with the result.
    final result = await addSiteUseCase(site);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (newSite) {
        // On success, manually update the list of sites.
        final currentSites = state.valueOrNull ?? [];
        state = AsyncValue.data([...currentSites, newSite]);
      },
    );
  }

  Future<void> deleteSite(String id) async {
    final deleteSiteUseCase = ref.read(deleteSiteUseCaseProvider);

    state = const AsyncValue.loading();

    final result = await deleteSiteUseCase(id);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        // On success, remove the site from the list.
        final currentSites = state.valueOrNull ?? [];
        state = AsyncValue.data(
          currentSites.where((site) => site.id != id).toList(),
        );
      },
    );
  }

  Future<void> refresh() async {
    // By invalidating the provider, we trigger the `build` method to run again.
    ref.invalidate(sitesNotifierProvider);
  }
}
