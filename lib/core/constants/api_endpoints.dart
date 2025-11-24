import 'app_constants.dart';

class ApiEndpoints {
  // Endpoints principaux de l'API WordPress
  static const String dashboardStats = '/dashboard-stats';
  static const String siteHealth = '/health-check';
  static const String comments = '/comments';
  static const String approveComment = '/comments/approve';
  static const String deleteComment = '/comments/delete';
  static const String siteInfo = '/site-info';
  static const String quickActions = '/quick-actions';
  
  // Construction des URLs complètes
  static String buildEndpoint(String baseUrl, String endpoint) {
    return '$baseUrl${AppConstants.defaultWPApiBase}${AppConstants.pluginNamespace}$endpoint';
  }
}
