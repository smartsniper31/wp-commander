import '../entities/stats_entity.dart';

abstract class StatsRepository {
  Future<StatsEntity> getStats(String siteId);
}
