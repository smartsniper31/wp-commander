import 'package:either_dart/either.dart';

import '../../repositories/health_repository.dart';
import '../base_usecase.dart';

class MonitorHealthUseCase extends UseCase<void, String> {
  final HealthRepository repository;

  MonitorHealthUseCase(this.repository);

  @override
  Future<UseCaseResult<void>> execute(String siteId) async {
    final result = await repository.monitorSiteUptime(siteId);
    return result.map((_) => null);
  }
}
