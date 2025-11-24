import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/domain/usecases/sites/add_site.dart';
import 'package:wp_commander/domain/usecases/sites/delete_site.dart';
import 'package:wp_commander/domain/usecases/sites/get_sites.dart';

part 'sites_notifier.g.dart';

@Riverpod(keepAlive: true)
class SitesNotifier extends _$SitesNotifier {
  @override
  Future<List<SiteEntity>> build() {
    // The build method now fetches the initial list of sites.
    // It will be re-run automatically when the provider is invalidated.
    return ref.watch(getSitesUseCaseProvider).call();
  }

  Future<void> addSite(SiteEntity site) async {
    // We get the use case via ref.read.
    final addSiteUseCase = ref.read(addSiteUseCaseProvider);
    
    await addSiteUseCase.call(site);

    // Invalidate the provider to trigger a refetch of the sites list.
    ref.invalidateSelf();
  }

  Future<void> deleteSite(SiteEntity site) async {
    final deleteSiteUseCase = ref.read(deleteSiteUseCaseProvider);
    await deleteSiteUseCase.call(site.id);
    
    // Invalidate the provider to trigger a refetch.
    ref.invalidateSelf();
  }

  Future<SiteEntity?> getSiteById(String id) async {
    final sites = await future;
    try {
      return sites.firstWhere((site) => site.id == id);
    } catch (e) {
      return null;
    }
  }
}
