import 'package:either_dart/either.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/health_repository.dart';
import '../base_usecase.dart';

class MonitorHealthUseCase extends UseCase<bool, String> {
  final HealthRepository repository;

  MonitorHealthUseCase(this.repository);

  @override
  Future<UseCaseResult<bool>> execute(String siteId) async {
    final result = await repository.monitorSiteUptime(siteId);
    return result.fold(
      (failure) =>
          UseCaseResult.error(UseCaseException(message: failure.message, code: 'HEALTH_MONITOR_FAILURE')),
      (isUp) => UseCaseResult.success(isUp),
    );
  }
}