import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/health_entity.dart';
import '../../../../domain/usecases/health/check_site_health_usecase.dart';
import '../../../core/providers/usecase_providers.dart';

// État pour le monitoring de santé
class HealthMonitorState {
  final HealthEntity health;
  final bool isLoading;
  final String? error;
  final bool isMonitoring;
  final DateTime lastChecked;

  const HealthMonitorState({
    required this.health,
    this.isLoading = false,
    this.error,
    this.isMonitoring = false,
    required this.lastChecked,
  });

  HealthMonitorState copyWith({
    HealthEntity? health,
    bool? isLoading,
    String? error,
    bool? isMonitoring,
    DateTime? lastChecked,
  }) {
    return HealthMonitorState(
      health: health ?? this.health,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isMonitoring: isMonitoring ?? this.isMonitoring,
      lastChecked: lastChecked ?? this.lastChecked,
    );
  }

  bool get hasError => error != null;
  bool get needsAttention => health.status != 'good';
  bool get isCritical => health.critical > 0;
}

// Notifier pour le monitoring de santé
class HealthMonitorNotifier extends StateNotifier<HealthMonitorState> {
  final CheckSiteHealthUseCase _checkSiteHealthUseCase;
  final String siteId;

  HealthMonitorNotifier({
    required CheckSiteHealthUseCase checkSiteHealthUseCase,
    required this.siteId,
  })  : _checkSiteHealthUseCase = checkSiteHealthUseCase,
        super(
          HealthMonitorState(
            health: HealthEntity.empty(),
            lastChecked: DateTime.now(),
          ),
        );

  // Vérifier la santé du site
  Future<void> checkHealth() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await _checkSiteHealthUseCase.execute(siteId);

    result.when(
      onSuccess: (health) {
        state = state.copyWith(
          health: health,
          isLoading: false,
          lastChecked: DateTime.now(),
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

  // Démarrer le monitoring automatique
  void startMonitoring() {
    state = state.copyWith(isMonitoring: true);
    // TODO: Implémenter le monitoring périodique
  }

  // Arrêter le monitoring
  void stopMonitoring() {
    state = state.copyWith(isMonitoring: false);
  }

  // Actualiser la santé
  Future<void> refreshHealth() async {
    await checkHealth();
  }

  // Effacer l'erreur
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider famille pour la santé par site
final healthMonitorProvider = StateNotifierProvider.family<
  HealthMonitorNotifier, HealthMonitorState, String>((ref, siteId) {
  return HealthMonitorNotifier(
    checkSiteHealthUseCase: ref.watch(checkSiteHealthUseCaseProvider),
    siteId: siteId,
  );
});
