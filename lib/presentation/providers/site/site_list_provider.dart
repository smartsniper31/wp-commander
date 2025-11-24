import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../../../../domain/entities/site_entity.dart';
import '../../../../domain/usecases/site/add_site_usecase.dart';
import '../../../../domain/usecases/site/validate_site_usecase.dart';
import '../../../core/providers/usecase_providers.dart';

// État pour la liste des sites
class SiteListState {
  final List<SiteEntity> sites;
  final bool isLoading;
  final String? error;
  final bool hasLoaded;

  const SiteListState({
    this.sites = const [],
    this.isLoading = false,
    this.error,
    this.hasLoaded = false,
  });

  SiteListState copyWith({
    List<SiteEntity>? sites,
    bool? isLoading,
    String? error,
    bool? hasLoaded,
  }) {
    return SiteListState(
      sites: sites ?? this.sites,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasLoaded: hasLoaded ?? this.hasLoaded,
    );
  }

  // Helpers
  bool get hasError => error != null;
  int get siteCount => sites.length;
  bool get isEmpty => sites.isEmpty && hasLoaded;
  bool get hasSites => sites.isNotEmpty;

  // Trouver un site par ID
  SiteEntity? findById(String id) {
    return sites.firstWhereOrNull((site) => site.id == id);
  }
}

// Notifier pour la liste des sites
class SiteListNotifier extends StateNotifier<SiteListState> {
  final AddSiteUseCase _addSiteUseCase;
  final ValidateSiteUseCase _validateSiteUseCase;

  SiteListNotifier({
    required AddSiteUseCase addSiteUseCase,
    required ValidateSiteUseCase validateSiteUseCase,
  })  : _addSiteUseCase = addSiteUseCase,
        _validateSiteUseCase = validateSiteUseCase,
        super(const SiteListState());

  // Charger les sites
  Future<void> loadSites() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // TODO: Implémenter le chargement depuis le repository
      await Future.delayed(const Duration(milliseconds: 500)); // Simulation
      
      final sites = <SiteEntity>[]; // Remplacer par l'appel réel
      
      state = state.copyWith(
        sites: sites,
        isLoading: false,
        hasLoaded: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement des sites: \${e.toString()}',
      );
    }
  }

  // Ajouter un site
  Future<void> addSite({
    required String name,
    required String url,
    required String apiKey,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _addSiteUseCase.execute(
      AddSiteParams(name: name, url: url, apiKey: apiKey),
    );

    result.when(
      onSuccess: (site) {
        final updatedSites = [...state.sites, site];
        state = state.copyWith(
          sites: updatedSites,
          isLoading: false,
        );
      },
      onError: (error) {
        state = state.copyWith(
          isLoading: false,
          error: error.message,
        );
      },
    );
  }

  // Valider un site
  Future<bool> validateSite(String url, String apiKey) async {
    final result = await _validateSiteUseCase.execute(
      ValidateSiteParams(url: url, apiKey: apiKey),
    );

    return result.isSuccess;
  }

  // Supprimer un site
  Future<void> deleteSite(String siteId) async {
    final updatedSites = state.sites.where((site) => site.id != siteId).toList();
    state = state.copyWith(sites: updatedSites);
    
    // TODO: Implémenter la suppression dans le repository
  }

  // Synchroniser un site
  Future<void> syncSite(String siteId) async {
    final site = state.findById(siteId);
    if (site == null) return;

    // Marquer le site comme en cours de synchronisation
    final updatedSites = state.sites.map((s) {
      if (s.id == siteId) {
        return s.copyWith(isConnected: false); // Temporairement déconnecté
      }
      return s;
    }).toList();

    state = state.copyWith(sites: updatedSites);

    // TODO: Implémenter la synchronisation réelle
    await Future.delayed(const Duration(seconds: 2));

    // Remettre à jour l'état
    final syncedSites = updatedSites.map((s) {
      if (s.id == siteId) {
        return s.copyWith(
          isConnected: true,
          lastSync: DateTime.now(),
        );
      }
      return s;
    }).toList();

    state = state.copyWith(sites: syncedSites);
  }

  // Effacer les erreurs
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Recharger les sites
  Future<void> refresh() async {
    await loadSites();
  }
}

// Provider pour la liste des sites
final siteListProvider = StateNotifierProvider<SiteListNotifier, SiteListState>((ref) {
  return SiteListNotifier(
    addSiteUseCase: ref.watch(addSiteUseCaseProvider),
    validateSiteUseCase: ref.watch(validateSiteUseCaseProvider),
  );
});

// Provider pour les sites récents
final recentSitesProvider = Provider<List<SiteEntity>>((ref) {
  final sites = ref.watch(siteListProvider).sites;
  sites.sort((a, b) => b.lastSync?.compareTo(a.lastSync ?? DateTime(0)) ?? 0);
  return sites.take(3).toList();
});

// Provider pour le nombre de sites
final siteCountProvider = Provider<int>((ref) {
  return ref.watch(siteListProvider).sites.length;
});
