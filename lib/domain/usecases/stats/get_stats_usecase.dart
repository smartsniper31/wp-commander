import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../entities/stats_entity.dart';
import '../../repositories/stats_repository.dart';

class GetStatsUseCase {
  final StatsRepository _repository;

  GetStatsUseCase(this._repository);

  Future<StatsEntity> execute(String siteId) async {
    try {
      if (siteId.isEmpty) {
        throw UseCaseException(
          message: 'ID de site invalide',
          code: 'INVALID_SITE_ID',
        );
      }

      return await _repository.getStats(siteId);
    } on RepositoryException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: e.toString());
    }
  }
}

final getStatsUseCaseProvider = Provider<GetStatsUseCase>((ref) {
  final repository = ref.watch(statsRepositoryProvider);
  return GetStatsUseCase(repository);
});
