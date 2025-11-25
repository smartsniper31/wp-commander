import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/services/sync_service.dart';
import '../../../core/providers/repository_providers.dart';

class SyncState {
  final bool isSyncing;
  final String? currentSiteId;
  final double progress;
  final String? error;
  final DateTime? lastSync;
  final List<String> syncQueue;

  const SyncState({
    this.isSyncing = false,
    this.currentSiteId,
    this.progress = 0.0,
    this.error,
    this.lastSync,
    this.syncQueue = const [],
  });

  SyncState copyWith({
    bool? isSyncing,
    String? currentSiteId,
    double? progress,
    String? error,
    DateTime? lastSync,
    List<String>? syncQueue,
  }) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      currentSiteId: currentSiteId ?? this.currentSiteId,
      progress: progress ?? this.progress,
      error: error,
      lastSync: lastSync ?? this.lastSync,
      syncQueue: syncQueue ?? this.syncQueue,
    );
  }
}

class SyncNotifier extends StateNotifier<SyncState> {
  final SyncService syncService;

  SyncNotifier(this.syncService) : super(const SyncState());

  Future<void> syncSite(String siteId) async {
    if (state.isSyncing) return;

    state = state.copyWith(
      isSyncing: true,
      currentSiteId: siteId,
      progress: 0.0,
      error: null,
    );

    try {
      final result = await syncService.syncSite(siteId);

      state = state.copyWith(
        isSyncing: false,
        progress: 1.0,
        lastSync: DateTime.now(),
      );

      if (!result.success) {
        throw Exception(result.error);
      }
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        error: 'Sync failed: ${e.toString()}',
      );
    }
  }

  Future<void> syncAllSites(List<String> siteIds) async {
    if (state.isSyncing) return;

    state = state.copyWith(
      isSyncing: true,
      syncQueue: siteIds,
      progress: 0.0,
      error: null,
    );

    try {
      final result = await syncService.syncAllSites();

      state = state.copyWith(
        isSyncing: false,
        syncQueue: [],
        progress: 1.0,
        lastSync: DateTime.now(),
      );

      if (result.failed > 0) {
        throw Exception('${result.failed} sites failed to sync');
      }
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        error: 'Batch sync failed: ${e.toString()}',
      );
    }
  }

  void updateProgress(double progress) {
    state = state.copyWith(progress: progress);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void cancelSync() {
    state = const SyncState();
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    siteRepository: ref.watch(siteRepositoryProvider),
    statsRepository: ref.watch(statsRepositoryProvider),
    healthRepository: ref.watch(healthRepositoryProvider),
    commentsRepository: ref.watch(commentsRepositoryProvider),
  );
});

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref.watch(syncServiceProvider));
});