import '../../../domain/repositories/stats_repository.dart';
import '../../../domain/entities/stats_entity.dart';

class GetStats {
  final StatsRepository repository;

  GetStats(this.repository);

  Future<StatsEntity> execute(String siteId) {
    return repository.getStats(siteId);
  }
}
