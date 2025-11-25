import 'package:either_dart/either.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/site_entity.dart';
import '../../domain/repositories/site_repository.dart';
import '../datasources/local/site_local_datasource.dart';
import '../datasources/remote/wp_api_datasource.dart'; // Correction de l'import

class SiteRepositoryImpl implements SiteRepository {
  final SiteLocalDataSource localDataSource;

  SiteRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, SiteEntity>> addSite(SiteEntity site) async {
    try {
      final remoteDataSource = WPApiDataSource(baseUrl: site.url, apiKey: site.apiKey);
      final isValid = await remoteDataSource.validateConnection();

      if (isValid) {
        final newSite = await localDataSource.cacheSite(site);
        return Right(newSite);
      } else {
        return Left(Failure.server(
            message: 'Invalid credentials or unable to connect.'));
      }
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } on CacheException {
      return Left(Failure.cache());
    }
  }

  @override
  Future<Either<Failure, void>> deleteSite(String id) async {
    try {
      await localDataSource.deleteSite(id);
      return const Right(null);
    } on CacheException {
      return Left(Failure.cache());
    }
  }

  @override
  Future<Either<Failure, List<SiteEntity>>> getSites() async {
    try {
      final sites = await localDataSource.getSites();
      return Right(sites);
    } on CacheException {
      return Left(Failure.cache());
    }
  }

  @override
  Future<Either<Failure, SiteEntity>> getSiteById(String id) async {
    try {
      final site = await localDataSource.getSite(id);
      return Right(site);
    } on CacheException {
      return Left(Failure.cache());
    }
  }

  @override
  Future<Either<Failure, void>> updateSite(SiteEntity site) async {
    try {
      await localDataSource.updateSite(site);
      return const Right(null);
    } on CacheException {
      return Left(Failure.cache());
    }
  }

  @override
  Future<bool> validateApiKey({required String url, required String apiKey}) async {
    try {
      final remoteDataSource = WPApiDataSource(baseUrl: url, apiKey: apiKey);
      return await remoteDataSource.validateConnection();
    } catch (_) {
      return false;
    }
  }
}
