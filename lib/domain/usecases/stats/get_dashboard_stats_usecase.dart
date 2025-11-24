import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/stats_repository.dart';
import '../../entities/stats_entity.dart';
import '../base_usecase.dart';

class GetDashboardStatsUseCase extends UseCase<StatsEntity, String> {
  final StatsRepository repository;

  GetDashboardStatsUseCase(this.repository);

  @override
  Future<UseCaseResult<StatsEntity>> execute(String siteId) async {
    try {
      if (siteId.isEmpty) {
        return UseCaseResult.error(
          UseCaseException(
            message: 'ID de site invalide',
            code: 'INVALID_SITE_ID',
          ),
        );
      }

      final stats = await repository.getDashboardStats(siteId);
      
      return UseCaseResult.success(stats);
    } on RepositoryException catch (e) {
      return UseCaseResult.error(
        UseCaseException(
          message: e.message,
          code: e.code,
        ),
      );
    } catch (e) {
      return UseCaseResult.error(
        UseCaseException(
          message: 'Erreur lors de la récupération des statistiques',
          code: 'STATS_FETCH_ERROR',
        ),
      );
    }
  }
}
