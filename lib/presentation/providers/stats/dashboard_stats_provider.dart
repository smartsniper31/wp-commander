import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/stats_entity.dart';
import '../../../../domain/usecases/stats/get_dashboard_stats_usecase.dart';
import '../../../core/providers/usecase_providers.dart';

// État pour les statistiques du dashboard
class DashboardStatsState {
  final StatsEntity stats;
  final bool isLoading;
  final String? error;
  final DateTime lastUpdated;

  const DashboardStatsState({
    required this.stats,
    this.isLoading = false,
    this.error,
    required this.lastUpdated,
  });

  DashboardStatsState copyWith({
    StatsEntity? stats,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return DashboardStatsState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  bool get hasError => error != null;
  bool get isStale {
    return DateTime.now().difference(lastUpdated).inMinutes > 15;
  }
}

// Notifier pour les statistiques du dashboard
class DashboardStatsNotifier extends StateNotifier<DashboardStatsState> {
  final GetDashboardStatsUseCase _getDashboardStatsUseCase;
  final String siteId;

  DashboardStatsNotifier({
    required GetDashboardStatsUseCase getDashboardStatsUseCase,
    required this.siteId,
  })  : _getDashboardStatsUseCase = getDashboardStatsUseCase,
        super(
          DashboardStatsState(
            stats: StatsEntity.empty(),
            lastUpdated: DateTime.now(),
          ),
        );

  // Charger les statistiques
  Future<void> loadStats() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await _getDashboardStatsUseCase.execute(siteId);

    result.when(
      onSuccess: (stats) {
        state = state.copyWith(
          stats: stats,
          isLoading: false,
          lastUpdated: DateTime.now(),
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

  // Actualiser les statistiques
  Future<void> refreshStats() async {
    await loadStats();
  }

  // Effacer l'erreur
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider famille pour les statistiques par site
final dashboardStatsProvider = StateNotifierProvider.family<
  DashboardStatsNotifier, DashboardStatsState, String>((ref, siteId) {
  return DashboardStatsNotifier(
    getDashboardStatsUseCase: ref.watch(getDashboardStatsUseCaseProvider),
    siteId: siteId,
  );
});
