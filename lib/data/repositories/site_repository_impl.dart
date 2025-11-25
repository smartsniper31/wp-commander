import 'package:either_dart/either.dart';
import 'package:wp_commander/data/datasources/site_remote_datasource.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/site_entity.dart';
import '../../domain/repositories/site_repository.dart';
import '../datasources/local/site_local_datasource.dart';
import '../datasources/remote/wp_api_datasource.dart';
import '../models/site_model.dart';

class SiteRepositoryImpl implements SiteRepository {
  final SiteLocalDataSource localDataSource;

  SiteRepositoryImpl({required this.localDataSource, required SiteRemoteDataSource remoteDataSource});

  @override
  Future<Either<Failure, SiteEntity>> addSite(SiteEntity site) async {
    try {
      final remoteDataSource = WPApiDataSource(baseUrl: site.url, apiKey: site.apiKey);
      final isValid = await remoteDataSource.validateConnection();

      if (isValid) {
        final newSite = await localDataSource.addSite(SiteModel(
          id: site.id,
          name: site.name,
          url: site.url,
          apiKey: site.apiKey,
          createdAt: site.createdAt,
        ));
        return Right(newSite);
      } else {
        return Left(Failure.server());
      }
    } on ServerException catch (_) {
      return Left(Failure.server());
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
      final site = await localDataSource.getSiteById(id);
      if (site != null) {
        return Right(site);
      }
      return Left(Failure.cache());
    } on CacheException {
      return Left(Failure.cache());
    }
  }

  @override
  Future<Either<Failure, void>> updateSite(SiteEntity site) async {
    try {
      await localDataSource.updateSite(SiteModel(
        id: site.id,
        name: site.name,
        url: site.url,
        apiKey: site.apiKey,
        createdAt: site.createdAt,
      ));
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
