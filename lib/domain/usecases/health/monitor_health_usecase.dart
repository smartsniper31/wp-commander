import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/health_repository.dart';
import '../base_usecase.dart';

class MonitorHealthUseCase extends UseCase<void, String> {
  final HealthRepository repository;

  MonitorHealthUseCase(this.repository);

  @override
  Future<UseCaseResult<void>> execute(String siteId) async {
    // TODO: Implémenter
    throw UnimplementedError();
  }
}
