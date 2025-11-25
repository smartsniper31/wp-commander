class ServerException implements Exception {
  final String? message;
  final String? code;

  ServerException({this.message, this.code});
}

class CacheException implements Exception {}

class RepositoryException implements Exception {
  final String message;

  RepositoryException({required this.message});
}

class UseCaseException implements Exception {
  final String message;
  final String? code;

  UseCaseException({required this.message, this.code});
}
