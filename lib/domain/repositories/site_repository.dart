import '../entities/site_entity.dart';

abstract class SiteRepository {
  Future<List<SiteEntity>> getSites();
  Future<SiteEntity> addSite(SiteEntity site);
  Future<void> deleteSite(String id);
}
