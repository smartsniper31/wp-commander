
import '../../repositories/stats_repository.dart';
import '../base_usecase.dart';

class RefreshStatsUseCase extends UseCase<void, String> {
  final StatsRepository repository;

  RefreshStatsUseCase(this.repository);

  @override
  Future<UseCaseResult<void>> execute(String siteId) async {
    try {
      await repository.refreshStats(siteId);
      return UseCaseResult.success(null);
    } on RepositoryException catch (e) {
      return UseCaseResult.error(UseCaseException(message: e.message, code: e.code));
    } catch (e) {
      return UseCaseResult.error(UseCaseException(message: e.toString(), code: 'UNKNOWN'));
    }
  }
}
