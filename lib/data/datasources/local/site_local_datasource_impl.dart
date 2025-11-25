import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/site_model.dart';
import 'site_local_datasource.dart';

const cachedSitesList = 'CACHED_SITES_LIST';

class SiteLocalDataSourceImpl implements SiteLocalDataSource {
  // SharedPreferences n'est plus requis dans le constructeur
  SiteLocalDataSourceImpl();

  @override
  Future<List<SiteModel>> getSites() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = sharedPreferences.getString(cachedSitesList);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final sites = jsonList.map((json) => SiteModel.fromJson(json)).toList();
      return Future.value(sites);
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<void> cacheSites(List<SiteModel> sites) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final jsonList = sites.map((site) => site.toJson()).toList();
    await sharedPreferences.setString(cachedSitesList, json.encode(jsonList));
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
    } else {
      throw CacheException();
    }
  }
}
