import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/errors/exceptions.dart';
import 'package:wp_commander/data/repositories/site_repository_impl.dart';
import 'package:wp_commander/data/adapters/api_adapter.dart';
import 'package:wp_commander/data/models/api/wp_health_model.dart';
import 'package:wp_commander/domain/entities/health_issue_entity.dart';
import '../../domain/repositories/health_repository.dart';
import '../../domain/entities/health_entity.dart';
import '../datasources/remote/wp_api_datasource.dart';
import '../datasources/local/cache_manager.dart';
import '../../core/providers/repository_providers.dart';

class HealthRepositoryImpl implements HealthRepository {
  final Ref ref;

  HealthRepositoryImpl(this.ref);

  Future<WPApiDataSource> _getDataSource(String siteId) async {
    final siteRepository = ref.read(siteRepositoryProvider);
    final site = await siteRepository.getSiteById(siteId);
    if (site != null) {
      return WPApiDataSource(
        baseUrl: site.url,
        apiKey: site.apiKey,
      );
    } else {
      throw UseCaseException(message: 'Site not found with ID: $siteId', code: 'SITE_NOT_FOUND');
    }
  }

  @override
  Future<HealthEntity> getSiteHealth(String siteId) async {
    final cacheKey = 'health_$siteId';
    try {
      final cachedData = await CacheManager.getValidData(cacheKey);
      if (cachedData != null && cachedData.isNotEmpty) {
        final healthData = jsonDecode(cachedData);
        return ApiAdapter.fromWpHealth(WPHealthModel.fromJson(healthData));
      }
    } catch (e) {
      // Cache is invalid or corrupted, fetch from network
    }

    try {
      final dataSource = await _getDataSource(siteId);
      final healthData = await dataSource.getSiteHealth();

      await CacheManager.save(
        key: cacheKey,
        data: jsonEncode(healthData.toJson()),
        dataType: 'health',
        siteId: siteId,
      );
      return ApiAdapter.fromWpHealth(healthData);
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: 'Failed to get site health: ${e.toString()}');
    }
  }

  @override
  Future<List<HealthIssue>> runHealthCheck(String siteId) async {
    try {
      final health = await getSiteHealth(siteId);
      return health.issues;
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: 'Failed to run health check: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getPerformanceMetrics(String siteId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final healthData = await dataSource.getSiteHealth();
      return {
        'responseTime': healthData.responseTime,
        'phpVersion': healthData.phpVersion,
        'wordpressVersion': healthData.wordpressVersion,
      };
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: 'Failed to get performance metrics: ${e.toString()}');
    }
  }

  @override
  Future<bool> monitorSiteUptime(String siteId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final healthData = await dataSource.getSiteHealth();
      return healthData.isOnline;
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: 'Failed to monitor site uptime: ${e.toString()}');
    }
  }
}
