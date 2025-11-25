import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CacheManager {
  static const String _cachePrefix = 'cache_';
  static const Duration _defaultExpiry = Duration(minutes: 15);

  static Future<void> save({
    required String key,
    required String data,
    required String dataType,
    required String siteId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cachePrefix$key';
    final cacheItem = {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
      'dataType': dataType,
      'siteId': siteId,
    };
    await prefs.setString(cacheKey, json.encode(cacheItem));
  }

  static Future<String?> getValidData(String key, {Duration? maxAge}) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cachePrefix$key';
    final itemString = prefs.getString(cacheKey);

    if (itemString == null) return null;

    final cacheItem = json.decode(itemString);
    final timestamp = DateTime.parse(cacheItem['timestamp']);
    final age = DateTime.now().difference(timestamp);

    if (age > (maxAge ?? _defaultExpiry)) {
      return null;
    }

    return cacheItem['data'];
  }

  static Future<Map<String, dynamic>?> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cachePrefix$key';
    final itemString = prefs.getString(cacheKey);
    if (itemString == null) return null;
    return json.decode(itemString);
  }
  
  static Future<void> clearCacheByType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (String key in keys) {
        if (key.startsWith(_cachePrefix)) {
            final itemString = prefs.getString(key);
            if (itemString != null) {
                final item = json.decode(itemString);
                if(item['dataType'] == type) {
                    await prefs.remove(key);
                }
            }
        }
    }
  }
}
