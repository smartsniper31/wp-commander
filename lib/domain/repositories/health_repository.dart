import 'package:either_dart/either.dart';

import '../../core/errors/failures.dart';
import '../entities/health_entity.dart';
import '../entities/health_issue_entity.dart';

abstract class HealthRepository {
  Future<Either<Failure, HealthEntity>> getSiteHealth(String siteId);
  Future<Either<Failure, List<HealthIssue>>> runHealthCheck(String siteId);
  Future<Either<Failure, Map<String, dynamic>>> getPerformanceMetrics(
      String siteId);
  Future<Either<Failure, bool>> monitorSiteUptime(String siteId);
}
