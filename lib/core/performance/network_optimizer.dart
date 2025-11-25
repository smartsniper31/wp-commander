import 'package:http/http.dart' as http;
import 'package:wp_commander/core/performance/performance_monitor.dart';

class OptimizedApiClient {
  static final Map<String, dynamic> _cache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _defaultCacheDuration = Duration(minutes: 5);

  static Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    Duration cacheDuration = _defaultCacheDuration,
  }) async {
    final now = DateTime.now();
    final cacheKey = _generateCacheKey(url, headers);

    // Vérifier le cache
    if (_cache.containsKey(cacheKey)) {
      final timestamp = _cacheTimestamps[cacheKey]!;
      if (now.difference(timestamp) < cacheDuration) {
        return _cache[cacheKey] as http.Response;
      }
    } else {
        // Cache expiré
        _cache.remove(cacheKey);
        _cacheTimestamps.remove(cacheKey);
    }

    // Faire la requête
    final stopwatch = Stopwatch()..start();
    final response = await http.get(Uri.parse(url), headers: headers);
    stopwatch.stop();

    // Mettre en cache si réussite
    if (response.statusCode == 200) {
      _cache[cacheKey] = response;
      _cacheTimestamps[cacheKey] = now;
    }

    PerformanceMonitor.startTracking('api_get_$url');
    PerformanceMonitor.endTracking('api_get_$url');

    return response;
  }

  static String _generateCacheKey(String url, Map<String, String>? headers) {
    final headerString = headers?.entries.map((e) => '${e.key}:${e.value}').join('|') ?? '';
    return '$url|$headerString';
  }

  static void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  static int get cacheSize => _cache.length;
}