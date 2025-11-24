import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/stats_repository.dart';
import '../base_usecase.dart';

class RefreshStatsUseCase extends UseCase<void, String> {
  final StatsRepository repository;

  RefreshStatsUseCase(this.repository);

  @override
  Future<UseCaseResult<void>> execute(String siteId) async {
    // TODO: Implémenter
    throw UnimplementedError();
  }
}
