class PerformanceConfig {
  // Cache
  static const Duration apiCacheDuration = Duration(minutes: 5);
  static const Duration imageCacheDuration = Duration(minutes: 10);
  static const int maxCacheSize = 100;

  // Réseau
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // UI
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration debounceDuration = Duration(milliseconds: 500);

  // Mémoire
  static const int maxMemoryUsage = 100 * 1024 * 1024; // 100MB

  static Map<String, dynamic> toMap() {
    return {
      'api_cache_duration': apiCacheDuration.inMinutes,
      'image_cache_duration': imageCacheDuration.inMinutes,
      'max_cache_size': maxCacheSize,
      'api_timeout': apiTimeout.inSeconds,
      'max_retries': maxRetries,
      'animation_duration': animationDuration.inMilliseconds,
      'debounce_duration': debounceDuration.inMilliseconds,
      'max_memory_usage': maxMemoryUsage,
    };
  }
}