import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/site_model.dart';

abstract class SiteLocalDataSource {
  Future<List<SiteModel>> getSites();
  Future<SiteModel> cacheSite(SiteModel site);
  Future<void> cacheSites(List<SiteModel> sites);
  Future<void> deleteSite(String id);
}

const cachedSitesKey = 'CACHED_SITES';

class SiteLocalDataSourceImpl implements SiteLocalDataSource {
  final SharedPreferences sharedPreferences;

  SiteLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheSites(List<SiteModel> sites) {
    final siteList = sites.map((site) => json.encode(site.toJson())).toList();
    return sharedPreferences.setStringList(cachedSitesKey, siteList);
  }

  @override
  Future<List<SiteModel>> getSites() {
    final jsonStringList = sharedPreferences.getStringList(cachedSitesKey);
    if (jsonStringList != null) {
      try {
        final sites = jsonStringList
            .map((jsonString) => SiteModel.fromJson(json.decode(jsonString)))
            .toList();
        return Future.value(sites);
      } catch (e) {
        return Future.value([]); // Return empty list on parsing error
      }
    } else {
      return Future.value([]); // Return empty list if no sites are cached
    }
  }

  @override
  Future<void> deleteSite(String id) async {
    final sites = await getSites();
    sites.removeWhere((site) => site.id == id);
    await cacheSites(sites);
  }

  @override
  Future<SiteModel> cacheSite(SiteModel site) async {
    final sites = await getSites();
    sites.removeWhere((s) => s.id == site.id); // Remove if exists to update
    sites.add(site);
    await cacheSites(sites);
    return site;
  }
}
