import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/site_model.dart';
import 'site_local_datasource.dart';

const cachedSitesList = 'CACHED_SITES_LIST';

class SiteLocalDataSourceImpl implements SiteLocalDataSource {
  final SharedPreferences sharedPreferences;

  SiteLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<SiteModel>> getSites() {
    final jsonStringList = sharedPreferences.getStringList(cachedSitesList);
    if (jsonStringList != null) {
      final sites = Future.value(jsonStringList
          .map((jsonString) => SiteModel.fromJson(json.decode(jsonString)))
          .toList());
      return sites;
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<void> cacheSites(List<SiteModel> sites) {
    final siteJsonList = sites.map((site) => json.encode(site.toJson())).toList();
    return sharedPreferences.setStringList(cachedSitesList, siteJsonList);
  }

  @override
  Future<SiteModel> addSite(SiteModel site) async {
    final sites = await getSites();
    sites.add(site);
    await cacheSites(sites);
    return site;
  }

  @override
  Future<void> deleteSite(String id) async {
    final sites = await getSites();
    sites.removeWhere((site) => site.id == id);
    await cacheSites(sites);
  }

  @override
  Future<SiteModel?> getSiteById(String id) async {
    final sites = await getSites();
    try {
      return sites.firstWhere((site) => site.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateSite(SiteModel site) async {
    final sites = await getSites();
    final index = sites.indexWhere((s) => s.id == site.id);
    if (index != -1) {
      sites[index] = site;
      await cacheSites(sites);
    }
  }
}
