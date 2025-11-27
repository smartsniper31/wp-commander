import 'package:either_dart/either.dart';

import 'package:wp_commander/core/errors/failures.dart';
import '../entities/stats_entity.dart';

abstract class StatsRepository {
  Future<Either<Failure, StatsEntity>> getStats(String siteId);
  Future<Either<Failure, StatsEntity>> getCachedStats(String siteId);
  Future<Either<Failure, void>> refreshStats(String siteId);
  Future<Either<Failure, Map<String, dynamic>>> getAdvancedAnalytics(
      String siteId);
  Future<Either<Failure, bool>> areStatsStale(String siteId);
}
