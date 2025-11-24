import '../entities/health_entity.dart';

abstract class HealthRepository {
  Future<HealthEntity> getSiteHealth(String siteId);
  Future<List<HealthIssue>> runHealthCheck(String siteId);
  Future<Map<String, dynamic>> getPerformanceMetrics(String siteId);
  Future<bool> monitorSiteUptime(String siteId);
}
