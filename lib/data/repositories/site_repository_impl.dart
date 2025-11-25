import 'package:wp_commander/data/datasources/site_remote_datasource.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/site_entity.dart';
import '../../domain/repositories/site_repository.dart';
import '../datasources/local/site_local_datasource.dart';
import '../datasources/remote/wp_api_datasource.dart';
import '../models/site_model.dart';

class SiteRepositoryImpl implements SiteRepository {
  final SiteLocalDataSource localDataSource;
  final SiteRemoteDataSource remoteDataSource;

  SiteRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<SiteEntity> addSite(SiteEntity site) async {
    try {
      final remoteApi = WPApiDataSource(baseUrl: site.url, apiKey: site.apiKey);
      final isValid = await remoteApi.validateConnection();

      if (isValid) {
        final newSite = await localDataSource.addSite(SiteModel.fromEntity(site));
        return newSite;
      } else {
        throw ServerException(message: 'Validation failed');
      }
    } on ServerException catch (e) {
      // Re-throw as a domain-specific exception if needed, or handle here.
      throw UseCaseException(message: 'Server error during site addition: ${e.message}');
    } on CacheException {
      throw UseCaseException(message: 'An unknown cache error occurred');
    }
  }

  @override
  Future<void> deleteSite(String id) async {
    try {
      await localDataSource.deleteSite(id);
    } on CacheException {
      throw UseCaseException(message: 'An unknown cache error occurred');
    }
  }

  @override
  Future<List<SiteEntity>> getSites() async {
    try {
      final sites = await localDataSource.getSites();
      return sites;
    } on CacheException {
      throw UseCaseException(message: 'An unknown cache error occurred');
    }
  }

  @override
  Future<SiteEntity?> getSiteById(String id) async {
    try {
      return await localDataSource.getSiteById(id);
    } on CacheException {
      throw UseCaseException(message: 'An unknown cache error occurred');
    }
  }

  @override
  Future<void> updateSite(SiteEntity site) async {
    try {
      await localDataSource.updateSite(SiteModel.fromEntity(site));
    } on CacheException {
      throw UseCaseException(message: 'An unknown cache error occurred');
    }
  }

  @override
  Future<bool> validateApiKey({
    required String url,
    required String apiKey,
  }) async {
    try {
      final remoteApi = WPApiDataSource(baseUrl: url, apiKey: apiKey);
      return await remoteApi.validateConnection();
    } on ServerException {
      // In validation, we might just return false instead of throwing.
      return false;
    }
  }
}

// We need a fromEntity method in SiteModel
