import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'base_api_datasource.dart';
import '../../models/api/wp_site_model.dart';
import '../../models/api/wp_stats_model.dart';
import '../../models/api/wp_health_model.dart';

class WPApiDataSource extends BaseApiDataSource {
  final _log = Logger('WPApiDataSource');

  WPApiDataSource({
    required super.baseUrl,
    required super.apiKey,
  });

  // Récupérer les informations du site
  Future<WPSiteModel> getSiteInfo() async {
    try {
      final response = await get('/site-info');
      return WPSiteModel.fromJson(response['data'] ?? {});
    } on ApiException catch (e) {
      // Log spécifique pour le debug
      if (e.isUnauthorized) {
        if (kDebugMode) {
          _log.warning('🔐 Unauthorized - Check API Key');
        }
      }
      rethrow;
    }
  }

  // Récupérer les statistiques du dashboard
  Future<WPStatsModel> getDashboardStats() async {
    final response = await get('/dashboard-stats');
    return WPStatsModel.fromJson(response['data'] ?? {});
  }

  // Vérifier la santé du site
  Future<WPHealthModel> getSiteHealth() async {
    final response = await get('/health-check');
    return WPHealthModel.fromJson(response['data'] ?? {});
  }

  // Récupérer les commentaires
  Future<List<dynamic>> getComments({
    String status = 'all',
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await get(
      '/comments',
      queryParameters: {
        'status': status,
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );
    return response['data'] ?? [];
  }

  // Approuver un commentaire
  Future<bool> approveComment(int commentId) async {
    final response = await post(
      '/comments/approve',
      body: {'comment_id': commentId},
    );
    return response['success'] == true;
  }

  // Supprimer un commentaire
  Future<bool> deleteComment(int commentId) async {
    final response = await post(
      '/comments/delete',
      body: {'comment_id': commentId},
    );
    return response['success'] == true;
  }

  // Actions rapides
  Future<bool> clearCache() async {
    final response = await post('/quick-actions/clear-cache');
    return response['success'] == true;
  }

  Future<bool> toggleMaintenanceMode(bool enable) async {
    final response = await post(
      '/quick-actions/maintenance-mode',
      body: {'enable': enable},
    );
    return response['success'] == true;
  }

  // Tester la connexion au site
  Future<bool> testConnection() async {
    try {
      await getSiteInfo();
      return true;
    } on ApiException {
      return false;
    }
  }
}
