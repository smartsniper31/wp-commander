
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/site_entity.dart';
import '../../domain/repositories/site_repository.dart';
import '../datasources/site_local_datasource.dart';
import '../datasources/site_remote_datasource.dart';

class SiteRepositoryImpl implements SiteRepository {
  final SiteRemoteDataSource remoteDataSource;
  final SiteLocalDataSource localDataSource;

  SiteRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<SiteEntity> addSite(SiteEntity site) async {
    try {
      // 1. Valider le site en ligne
      final remoteSite = await remoteDataSource.getSite(site.url);
      
      // 2. Si valide, l'ajouter à la source de données locale
      final newSite = await localDataSource.cacheSite(remoteSite);
      return newSite;
    } on ServerException {
      throw Failure.server();
    } on CacheException {
      throw Failure.cache();
    }
  }

  @override
  Future<void> deleteSite(String id) async {
    try {
      await localDataSource.deleteSite(id);
    } on CacheException {
      throw Failure.cache();
    }
  }

  @override
  Future<List<SiteEntity>> getSites() async {
    try {
      final sites = await localDataSource.getSites();
      return sites;
    } on CacheException {
      return [];
    }
  }
}
