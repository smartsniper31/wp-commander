
import '../repositories/site_repository.dart';
import '../repositories/stats_repository.dart';
import '../repositories/health_repository.dart';
import '../repositories/comments_repository.dart';

class SyncService {
  final SiteRepository siteRepository;
  final StatsRepository statsRepository;
  final HealthRepository healthRepository;
  final CommentsRepository commentsRepository;

  SyncService({
    required this.siteRepository,
    required this.statsRepository,
    required this.healthRepository,
    required this.commentsRepository,
  });

  // Synchronisation complète d'un site
  Future<SyncResult> syncSite(String siteId) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      // Synchroniser dans l'ordre
      await siteRepository.syncSiteData(await siteRepository.getSiteById(siteId));
      await statsRepository.refreshStats(siteId);
      await healthRepository.getSiteHealth(siteId);
      await commentsRepository.getComments(siteId);

      stopwatch.stop();

      return SyncResult(
        success: true,
        siteId: siteId,
        duration: stopwatch.elapsed,
        syncedItems: ['site_info', 'stats', 'health', 'comments'],
        timestamp: DateTime.now(),
      );
    } catch (e) {
      stopwatch.stop();
      
      return SyncResult(
        success: false,
        siteId: siteId,
        duration: stopwatch.elapsed,
        error: e.toString(),
        timestamp: DateTime.now(),
      );
    }
  }

  // Synchronisation de tous les sites
  Future<BatchSyncResult> syncAllSites() async {
    final sites = await siteRepository.getSites();
    final results = <SyncResult>[];
    
    for (final site in sites) {
      final result = await syncSite(site.id);
      results.add(result);
      
      // Petit délai entre chaque synchronisation
      await Future.delayed(const Duration(seconds: 1));
    }

    final successful = results.where((r) => r.success).length;
    final failed = results.length - successful;

    return BatchSyncResult(
      total: results.length,
      successful: successful,
      failed: failed,
      results: results,
      timestamp: DateTime.now(),
    );
  }

  // Synchronisation intelligente (seulement si nécessaire)
  Future<SyncResult> smartSync(String siteId) async {
    final needsSync = await _needsSync(siteId);
    
    if (needsSync) {
      return await syncSite(siteId);
    }
    
    return SyncResult(
      success: true,
      siteId: siteId,
      duration: Duration.zero,
      syncedItems: ['cached_data'],
      timestamp: DateTime.now(),
      fromCache: true,
    );
  }

  Future<bool> _needsSync(String siteId) async {
    // Vérifier si les stats sont périmées
    final statsStale = await statsRepository.areStatsStale(siteId);
    if (statsStale) return true;

    // Vérifier si la santé du site est périmée
    // Implémenter similar logic for health checks

    return false;
  }
}

class SyncResult {
  final bool success;
  final String siteId;
  final Duration duration;
  final List<String> syncedItems;
  final String? error;
  final DateTime timestamp;
  final bool fromCache;

  const SyncResult({
    required this.success,
    required this.siteId,
    required this.duration,
    this.syncedItems = const [],
    this.error,
    required this.timestamp,
    this.fromCache = false,
  });
}

class BatchSyncResult {
  final int total;
  final int successful;
  final int failed;
  final List<SyncResult> results;
  final DateTime timestamp;

  const BatchSyncResult({
    required this.total,
    required this.successful,
    required this.failed,
    required this.results,
    required this.timestamp,
  });

  double get successRate => total > 0 ? successful / total : 0;
}