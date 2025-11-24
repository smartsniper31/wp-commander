import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../models/local/cached_data_model.dart';

class CacheManager {
  static const String _cacheBoxName = 'wp_commander_cache';
  static Box<CachedDataModel>? _cacheBox;
  static final _log = Logger('CacheManager');
  
  // Durées de cache par type de données
  static const Map<String, Duration> _cacheDurations = {
    'stats': Duration(minutes: 15),
    'health': Duration(minutes: 10),
    'comments': Duration(minutes: 5),
    'site_info': Duration(hours: 1),
    'analytics': Duration(hours: 2),
  };

  // Initialisation
  static Future<void> init() async {
    _cacheBox = await Hive.openBox<CachedDataModel>(_cacheBoxName);
    
    if (kDebugMode) {
      _log.info('💾 Cache Manager initialized');
    }
  }

  // Sauvegarder des données dans le cache
  static Future<void> save({
    required String key,
    required String data,
    required String dataType,
    required String siteId,
    Duration? customDuration,
  }) async {
    final duration = customDuration ?? _cacheDurations[dataType] ?? const Duration(minutes: 10);
    final expiresAt = DateTime.now().add(duration);
    
    final cacheItem = CachedDataModel(
      key: key,
      data: data,
      createdAt: DateTime.now(),
      expiresAt: expiresAt,
      dataType: dataType,
      siteId: siteId,
    );
    
    await _cacheBox!.put(key, cacheItem);
    
    if (kDebugMode) {
      _log.info('💾 Cache saved: $key (expires: $expiresAt)');
    }
  }

  // Récupérer des données du cache
  static CachedDataModel? get(String key) {
    final cacheItem = _cacheBox!.get(key);
    
    if (cacheItem != null && cacheItem.isExpired) {
      // Supprimer les données expirées
      _cacheBox!.delete(key);
      return null;
    }
    
    return cacheItem;
  }

  // Récupérer avec vérification d'expiration
  static String? getValidData(String key) {
    final cacheItem = get(key);
    if (cacheItem != null && cacheItem.isValid) {
      return cacheItem.data;
    }
    return null;
  }

  // Récupérer tous les cache pour un site
  static List<CachedDataModel> getSiteCache(String siteId) {
    return _cacheBox!.values
        .where((item) => item.siteId == siteId && item.isValid)
        .toList();
  }

  // Vérifier si une clé existe et est valide
  static bool hasValidCache(String key) {
    return get(key)?.isValid == true;
  }

  // Nettoyer le cache expiré
  static Future<void> cleanExpiredCache() async {
    final expiredKeys = <String>[];
    
    for (final key in _cacheBox!.keys) {
      final item = _cacheBox!.get(key);
      if (item != null && item.isExpired) {
        expiredKeys.add(key as String);
      }
    }
    
    await _cacheBox!.deleteAll(expiredKeys);
    
    if (kDebugMode && expiredKeys.isNotEmpty) {
      _log.info('🧹 Cleaned ${expiredKeys.length} expired cache items');
    }
  }

  // Nettoyer le cache par type
  static Future<void> clearCacheByType(String dataType) async {
    final keysToDelete = <String>[];
    
    for (final key in _cacheBox!.keys) {
      final item = _cacheBox!.get(key);
      if (item != null && item.dataType == dataType) {
        keysToDelete.add(key as String);
      }
    }
    
    await _cacheBox!.deleteAll(keysToDelete);
    
    if (kDebugMode) {
      _log.info('🗑️ Cleared cache for type: $dataType');
    }
  }

  // Statistiques du cache
  static CacheStats getStats() {
    final allItems = _cacheBox!.values.toList();
    final validItems = allItems.where((item) => item.isValid).toList();
    final expiredItems = allItems.where((item) => item.isExpired).toList();
    
    return CacheStats(
      totalItems: allItems.length,
      validItems: validItems.length,
      expiredItems: expiredItems.length,
      totalSize: allItems.fold(0, (sum, item) => sum + item.data.length),
    );
  }

  // Fermer la boîte de cache
  static Future<void> close() async {
    await _cacheBox?.close();
  }
}

class CacheStats {
  final int totalItems;
  final int validItems;
  final int expiredItems;
  final int totalSize; // en caractères

  const CacheStats({
    required this.totalItems,
    required this.validItems,
    required this.expiredItems,
    required this.totalSize,
  });

  double get validityRate => totalItems > 0 ? validItems / totalItems : 0;
  String get totalSizeFormatted {
    if (totalSize < 1024) return '${totalSize}B';
    if (totalSize < 1048576) return '${(totalSize / 1024).toStringAsFixed(1)}KB';
    return '${(totalSize / 1048576).toStringAsFixed(1)}MB';
  }
}
