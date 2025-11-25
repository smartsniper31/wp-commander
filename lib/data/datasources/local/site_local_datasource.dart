import '../../models/site_model.dart';

abstract class SiteLocalDataSource {
  Future<List<SiteModel>> getSites();
  Future<void> cacheSites(List<SiteModel> sites);
  Future<void> deleteSite(String id);
  Future<SiteModel?> getSiteById(String id);
  Future<SiteModel> addSite(SiteModel site);
  Future<void> updateSite(SiteModel site);
}
