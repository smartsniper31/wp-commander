import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/errors/exceptions.dart';
import '../models/site_model.dart';

abstract class SiteLocalDataSource {
  Future<List<SiteModel>> getSites();
  Future<SiteModel> cacheSite(SiteModel site);
  Future<void> cacheSites(List<SiteModel> sites);
  Future<void> deleteSite(String url);
}

const CACHED_SITES = 'CACHED_SITES';

class SiteLocalDataSourceImpl implements SiteLocalDataSource {
  final SharedPreferences sharedPreferences;

  SiteLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheSites(List<SiteModel> sites) {
    final siteList = sites.map((site) => json.encode(site.toJson())).toList();
    return sharedPreferences.setStringList(CACHED_SITES, siteList);
  }

  @override
  Future<List<SiteModel>> getSites() {
    final jsonStringList = sharedPreferences.getStringList(CACHED_SITES);
    if (jsonStringList != null) {
      final sites = jsonStringList
          .map((jsonString) => SiteModel.fromJson(json.decode(jsonString)))
          .toList();
      return Future.value(sites);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteSite(String url) async {
    final sites = await getSites();
    sites.removeWhere((site) => site.url == url);
    await cacheSites(sites);
  }

  @override
  Future<SiteModel> cacheSite(SiteModel site) async {
    final sites = await getSites();
    sites.add(site);
    await cacheSites(sites);
    return site;
  }
}
