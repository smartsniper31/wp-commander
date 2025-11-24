class AppConstants {
  // Version de l'application
  static const String appName = 'WP Commander';
  static const String appVersion = '1.0.0';
  
  // URLs et endpoints de base
  static const String defaultWPApiBase = '/wp-json';
  static const String pluginNamespace = '/wp-commander/v1';
  
  // Timeouts
  static const int apiTimeout = 30000; // 30 secondes
  static const int healthCheckInterval = 60000; // 1 minute
  
  // Configuration
  static const int maxSites = 10;
  static const int itemsPerPage = 20;
}

class AppRoutes {
  static const String dashboard = '/';
  static const String sites = '/sites';
  static const String addSite = '/sites/add';
  static const String siteDetail = '/sites/detail';
  static const String comments = '/comments';
  static const String health = '/health';
  static const String analytics = '/analytics';
  static const String settings = '/settings';
  
  // Helper pour les routes avec paramètres
  static String siteDetailWithId(String siteId) {
    return '$siteDetail?id=$siteId';
  }
}
