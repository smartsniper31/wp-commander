import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/providers/repository_providers.dart' show statsRepositoryProvider;

import '../../../core/errors/exceptions.dart';
import '../../repositories/stats_repository.dart';

class RefreshStatsUseCase {
  final StatsRepository _repository;

  RefreshStatsUseCase(this._repository);

  Future<void> execute(String siteId) async {
    try {
      await _repository.refreshStats(siteId);
    } on RepositoryException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: e.toString());
    }
  }
}

final refreshStatsUseCaseProvider = Provider<RefreshStatsUseCase>((ref) {
  final repository = ref.watch(statsRepositoryProvider);
  return RefreshStatsUseCase(repository);
});
