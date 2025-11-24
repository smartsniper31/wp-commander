import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsDataSource {
  static SharedPreferences? _prefs;

  // Initialisation
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Gestion des sites
  static Future<bool> saveSites(List<String> sitesJson) async {
    return await _prefs!.setStringList('wp_commander_sites', sitesJson);
  }

  static List<String> getSites() {
    return _prefs!.getStringList('wp_commander_sites') ?? [];
  }

  // Gestion des paramètres
  static Future<bool> saveSettings(Map<String, dynamic> settings) async {
    final jsonString = jsonEncode(settings);
    return await _prefs!.setString('wp_commander_settings', jsonString);
  }

  static Map<String, dynamic> getSettings() {
    final jsonString = _prefs!.getString('wp_commander_settings');
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return {};
  }

  // Cache des données
  static Future<bool> saveCache(String key, String data, Duration duration) async {
    final expiry = DateTime.now().add(duration).millisecondsSinceEpoch;
    final cacheData = {
      'data': data,
      'expiry': expiry,
    };
    return await _prefs!.setString('cache_$key', jsonEncode(cacheData));
  }

  static String? getCache(String key) {
    final cacheString = _prefs!.getString('cache_$key');
    if (cacheString != null) {
      final cacheData = jsonDecode(cacheString) as Map<String, dynamic>;
      final expiry = cacheData['expiry'] as int;
      
      if (DateTime.now().millisecondsSinceEpoch < expiry) {
        return cacheData['data'] as String;
      } else {
        // Supprimer le cache expiré
        _prefs!.remove('cache_$key');
      }
    }
    return null;
  }

  // Nettoyage
  static Future<void> clearAll() async {
    await _prefs!.clear();
  }

  static Future<void> clearCache() async {
    final keys = _prefs!.getKeys();
    for (final key in keys) {
      if (key.startsWith('cache_')) {
        await _prefs!.remove(key);
      }
    }
  }
}