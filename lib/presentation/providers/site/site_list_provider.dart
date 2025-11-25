import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/site_entity.dart';
import '../../../../domain/usecases/sites/add_site_usecase.dart';
import '../../../../domain/usecases/sites/delete_site_usecase.dart';
import '../../../../domain/usecases/sites/get_sites_usecase.dart';
import '../../../../domain/usecases/sites/update_site_usecase.dart';
import 'package:collection/collection.dart';
import '../../../../domain/repositories/site_repository.dart';
import '../../../core/providers/repository_providers.dart';

final siteListProvider =
    AsyncNotifierProvider<SiteListNotifier, List<SiteEntity>>(() {
  return SiteListNotifier();
});

class SiteListNotifier extends AsyncNotifier<List<SiteEntity>> {
  late final GetSitesUseCase _getSitesUseCase;
  late final AddSiteUseCase _addSiteUseCase;
  late final UpdateSiteUseCase _updateSiteUseCase;
  late final DeleteSiteUseCase _deleteSiteUseCase;
  late final SiteRepository _siteRepository;

  @override
  Future<List<SiteEntity>> build() async {
    _getSitesUseCase = ref.watch(getSitesUseCaseProvider);
    _addSiteUseCase = ref.watch(addSiteUseCaseProvider);
    _updateSiteUseCase = ref.watch(updateSiteUseCaseProvider);
    _deleteSiteUseCase = ref.watch(deleteSiteUseCaseProvider);
    _siteRepository = ref.watch(siteRepositoryProvider);

    return await _getSitesUseCase.execute();
  }

  Future<void> addSite(SiteEntity site) async {
    state = const AsyncValue.loading();
    try {
      final params = AddSiteParams(
        name: site.name,
        url: site.url,
        apiKey: site.apiKey,
      );
      final newSite = await _addSiteUseCase.execute(params);
      final currentSites = await future;
      state = AsyncValue.data([...currentSites, newSite]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateSite(SiteEntity site) async {
    state = const AsyncValue.loading();
    try {
      await _updateSiteUseCase.execute(site);
      final currentSites = await future;
      final index = currentSites.indexWhere((s) => s.id == site.id);
      if (index != -1) {
        final newSites = List<SiteEntity>.from(currentSites);
        newSites[index] = site;
        state = AsyncValue.data(newSites);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteSite(String id) async {
    state = const AsyncValue.loading();
    try {
      await _deleteSiteUseCase.execute(id);
      final currentSites = await future;
      state = AsyncValue.data(currentSites.where((s) => s.id != id).toList());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> validateApiKey(
      {required String url, required String apiKey}) async {
    return await _siteRepository.validateApiKey(url: url, apiKey: apiKey);
  }
}

final recentSitesProvider = Provider<List<SiteEntity>>((ref) {
  final sites = ref.watch(siteListProvider).asData?.value ?? [];
  sites.sort((a, b) {
    final dateA = a.createdAt ?? DateTime(1900);
    final dateB = b.createdAt ?? DateTime(1900);
    return dateB.compareTo(dateA);
  });
  return sites.take(3).toList();
});

final siteCountProvider = Provider<int>((ref) {
  return ref.watch(siteListProvider).asData?.value.length ?? 0;
});

final findSiteByIdProvider = Provider.family<SiteEntity?, String>((ref, id) {
  final sites = ref.watch(siteListProvider).asData?.value;
  return sites?.firstWhereOrNull((site) => site.id == id);
});
