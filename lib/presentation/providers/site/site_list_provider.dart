import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/site_entity.dart';
import '../../../../domain/usecases/sites/add_site.dart' hide addSiteUseCaseProvider;
import '../../../../domain/usecases/sites/delete_site.dart';
import '../../../../domain/usecases/sites/get_sites.dart';
import '../../../../domain/usecases/sites/update_site.dart';
import '../../../core/providers/usecase_providers.dart';
import 'package:collection/collection.dart';
import '../../../../core/errors/failures.dart';
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

    final result = await _getSitesUseCase();
    return result.fold(
      (failure) => throw failure,
      (sites) => sites,
    );
  }

  Future<void> addSite(SiteEntity site) async {
    state = const AsyncValue.loading();
    final result = await _addSiteUseCase(site);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (site) async {
        final currentState = await future;
        state = AsyncValue.data([...currentState, site]);
      },
    );
  }

  Future<void> updateSite(SiteEntity site) async {
    state = const AsyncValue.loading();
    final result = await _updateSiteUseCase(site);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) async {
        final currentState = await future;
        final index = currentState.indexWhere((s) => s.id == site.id);
        if (index != -1) {
          final newSites = List.from(currentState);
          newSites[index] = site;
          state = AsyncValue.data(newSites);
        }
      },
    );
  }

  Future<void> deleteSite(String id) async {
    state = const AsyncValue.loading();
    final result = await _deleteSiteUseCase(id);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) async {
        final currentState = await future;
        state = AsyncValue.data(currentState.where((s) => s.id != id).toList());
      },
    );
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

final findSiteByIdProvider =
    Provider.family<SiteEntity?, String>((ref, id) {
  final sites = ref.watch(siteListProvider).asData?.value;
  return sites?.firstWhereOrNull((site) => site.id == id);
});
