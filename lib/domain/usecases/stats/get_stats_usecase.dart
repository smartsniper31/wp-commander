import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/providers/repository_providers.dart' show statsRepositoryProvider;

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

      final result = await _repository.getStats(siteId);
      return result.fold(
        (failure) => throw UseCaseException(message: failure.message),
        (stats) => stats,
      );
    } on RepositoryException {
      rethrow;
    } catch (e) {
      if (e is UseCaseException) {
        rethrow;
      }
      throw UseCaseException(message: e.toString());
    }
  }
}

final getStatsUseCaseProvider = Provider<GetStatsUseCase>((ref) {
  final repository = ref.watch(statsRepositoryProvider);
  return GetStatsUseCase(repository);
});
