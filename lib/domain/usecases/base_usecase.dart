// Classe de base pour tous les use cases
abstract class UseCase<Result, Params> {
  Future<UseCaseResult<Result>> execute(Params params);
}

// Résultat standardisé pour tous les use cases
class UseCaseResult<Result> {
  final Result? data;
  final UseCaseException? error;
  final bool isSuccess;

  const UseCaseResult._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory UseCaseResult.success(Result data) {
    return UseCaseResult._(
      data: data,
      isSuccess: true,
    );
  }

  factory UseCaseResult.error(UseCaseException error) {
    return UseCaseResult._(
      error: error,
      isSuccess: false,
    );
  }

  // Helpers pour le traitement des résultats
  bool get isError => !isSuccess;
  
  void when({
    required Function(Result data) onSuccess,
    required Function(UseCaseException error) onError,
  }) {
    if (isSuccess && data != null) {
      onSuccess(data as Result);
    } else if (error != null) {
      onError(error!);
    }
  }
}

// Exception standardisée pour les use cases
class UseCaseException implements Exception {
  final String message;
  final String code;
  final DateTime timestamp;

  UseCaseException({
    required this.message,
    required this.code,
  }) : timestamp = DateTime.now();

  @override
  String toString() => 'UseCaseException(code: $code, message: $message)';
}

// Exception pour les repositories
class RepositoryException implements Exception {
  final String message;
  final String code;

  RepositoryException({required this.message, required this.code});

  @override
  String toString() => 'RepositoryException(code: $code, message: $message)';
}
