import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/data/adapters/api_adapter.dart';
import 'package:wp_commander/data/models/api/wp_health_model.dart';
import 'package:wp_commander/domain/entities/health_issue_entity.dart';
import 'package:wp_commander/presentation/notifiers/sites_notifier.dart';
import '../../domain/repositories/health_repository.dart';
import '../../domain/entities/health_entity.dart';
import '../datasources/remote/wp_api_datasource.dart';
import '../datasources/local/cache_manager.dart';

class HealthRepositoryImpl implements HealthRepository {
  final Ref ref;

  HealthRepositoryImpl(this.ref);

  Future<WPApiDataSource> _getDataSource(String siteId) async {
    final site = await ref.read(sitesNotifierProvider.notifier).getSiteById(siteId);
    return WPApiDataSource(
      baseUrl: site!.url,
      apiKey: site.apiKey,
    );
  }

  @override
  Future<HealthEntity> getSiteHealth(String siteId) async {
    final cacheKey = 'health_$siteId';
    final cachedData = CacheManager.getValidData(cacheKey);

    if (cachedData != null) {
      final healthData = jsonDecode(cachedData);
      return ApiAdapter.fromWpHealth(WPHealthModel.fromJson(healthData));
    }

    final dataSource = await _getDataSource(siteId);
    final healthData = await dataSource.getSiteHealth();

    await CacheManager.save(
      key: cacheKey,
      data: jsonEncode(healthData.toJson()),
      dataType: 'health',
      siteId: siteId,
    );

    return ApiAdapter.fromWpHealth(healthData);
  }

  @override
  Future<List<HealthIssue>> runHealthCheck(String siteId) async {
    final dataSource = await _getDataSource(siteId);
    final healthData = await dataSource.getSiteHealth();
    return healthData.issues.map((issue) => HealthIssue.fromJson(issue)).toList();
  }

  @override
  Future<Map<String, dynamic>> getPerformanceMetrics(String siteId) async {
    final dataSource = await _getDataSource(siteId);
    final healthData = await dataSource.getSiteHealth();
    return {
      'responseTime': healthData.responseTime,
      'phpVersion': healthData.phpVersion,
      'wordpressVersion': healthData.wordpressVersion,
    };
  }

  @override
  Future<bool> monitorSiteUptime(String siteId) async {
    final dataSource = await _getDataSource(siteId);
    final healthData = await dataSource.getSiteHealth();
    return healthData.isOnline;
  }
}
