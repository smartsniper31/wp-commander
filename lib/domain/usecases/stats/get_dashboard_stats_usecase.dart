import 'package:either_dart/either.dart';

import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/domain/entities/stats_entity.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/domain/repositories/stats_repository.dart';

class GetDashboardStatsUseCase {
  final StatsRepository repository;

  GetDashboardStatsUseCase(this.repository);

  Future<Either<Failure, StatsEntity>> call(SiteEntity site) async {
    return await repository.getStats(site.id);
  }

  Future<dynamic> execute(String siteId) async {}
}
