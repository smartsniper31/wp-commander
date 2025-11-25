import '../entities/site_entity.dart';

abstract class SiteRepository {
  Future<List<SiteEntity>> getSites();
  Future<SiteEntity?> getSiteById(String id);
  Future<SiteEntity> addSite(SiteEntity site);
  Future<void> deleteSite(String id);
  Future<void> updateSite(SiteEntity site);
  Future<bool> validateApiKey({required String url, required String apiKey});
}
