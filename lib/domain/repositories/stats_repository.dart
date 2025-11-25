import '../entities/stats_entity.dart';

abstract class StatsRepository {
  Future<StatsEntity> getStats(String siteId);
  Future<StatsEntity> getCachedStats(String siteId);
  Future<void> refreshStats(String siteId);
  Future<Map<String, dynamic>> getAdvancedAnalytics(String siteId);
  Future<bool> areStatsStale(String siteId);
}
