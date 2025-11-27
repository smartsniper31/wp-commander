import 'package:either_dart/either.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/data/datasources/site_remote_datasource.dart';
import '../../domain/entities/site_entity.dart';
import '../../domain/repositories/site_repository.dart';
import '../datasources/local/site_local_datasource.dart';
import '../models/site_model.dart';

class SiteRepositoryImpl implements SiteRepository {
  final SiteLocalDataSource localDataSource;
  final SiteRemoteDataSource remoteDataSource;

  SiteRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, SiteEntity>> addSite(SiteEntity site) async {
    try {
      final isValid = await remoteDataSource.validateConnection(site.url, site.apiKey);

      if (isValid) {
        final newSite = await localDataSource.addSite(SiteModel.fromEntity(site));
        return Right(newSite);
      } else {
        return Left(ServerFailure(message: 'Validation failed'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'An error occurred while adding the site.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSite(String id) async {
    try {
      await localDataSource.deleteSite(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'An error occurred while deleting the site.'));
    }
  }

  @override
  Future<Either<Failure, List<SiteEntity>>> getSites() async {
    try {
      final sites = await localDataSource.getSites();
      return Right(sites);
    } catch (e) {
      return Left(CacheFailure(message: 'An error occurred while fetching sites.'));
    }
  }

  @override
  Future<Either<Failure, SiteEntity?>> getSiteById(String id) async {
    try {
      final site = await localDataSource.getSiteById(id);
      return Right(site);
    } catch (e) {
      return Left(CacheFailure(message: 'An error occurred while fetching the site.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSite(SiteEntity site) async {
    try {
      await localDataSource.updateSite(SiteModel.fromEntity(site));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'An error occurred while updating the site.'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateApiKey({
    required String url,
    required String apiKey,
  }) async {
    try {
      final result = await remoteDataSource.validateConnection(url, apiKey);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: "Validation failed"));
    }
  }
}
