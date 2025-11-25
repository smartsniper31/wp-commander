import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import '../../domain/repositories/stats_repository.dart';
import '../../domain/entities/stats_entity.dart';
import '../datasources/remote/wp_api_datasource.dart';
import '../datasources/local/cache_manager.dart';
import '../adapters/api_adapter.dart';
import '../models/api/wp_stats_model.dart';
import '../../domain/entities/site_entity.dart';
import '../../core/errors/exceptions.dart';
import 'package:wp_commander/data/repositories/site_repository_impl.dart';
import '../../core/providers/repository_providers.dart';

class StatsRepositoryImpl implements StatsRepository {
  final Ref ref;

  StatsRepositoryImpl(this.ref);

  Future<SiteEntity> _getSiteById(String siteId) async {
    final site = await ref.read(siteRepositoryProvider).getSiteById(siteId);
    if (site == null) {
      throw UseCaseException(message: "Site not found: $siteId");
    }
    return site;
  }

  @override
  Future<StatsEntity> getStats(String siteId) async {
    try {
      final site = await _getSiteById(siteId);

      final apiDataSource = WPApiDataSource(
        baseUrl: site.url,
        apiKey: site.apiKey,
      );

      final statsModel = await apiDataSource.getDashboardStats();
      final statsEntity = ApiAdapter.statsModelToEntity(statsModel);

      await CacheManager.save(
        key: 'stats_$siteId',
        data: jsonEncode(statsModel.toJson()),
        dataType: 'stats',
        siteId: siteId,
      );

      return statsEntity;
    } catch (e) {
      if (e is UseCaseException) {
        rethrow;
      }
      try {
        final cachedStats = await getCachedStats(siteId);
        if (cachedStats != StatsEntity.empty()) {
          return cachedStats;
        }
      } catch (_) {
        //  If cache also fails, throw the original error
      }
      throw UseCaseException(
        message: 'Failed to get dashboard stats: ${e.toString()}',
      );
    }
  }

  @override
  Future<StatsEntity> getCachedStats(String siteId) async {
    try {
      final cachedData = await CacheManager.getValidData('stats_$siteId');
      if (cachedData != null) {
        final statsModel = WPStatsModel.fromJson(jsonDecode(cachedData));
        return ApiAdapter.statsModelToEntity(statsModel);
      }
      return StatsEntity.empty();
    } catch (e) {
      return StatsEntity.empty();
    }
  }

  @override
  Future<void> refreshStats(String siteId) async {
    await getStats(siteId);
  }

  @override
  Future<Map<String, dynamic>> getAdvancedAnalytics(String siteId) async {
    try {
      final site = await _getSiteById(siteId);
      final apiDataSource = WPApiDataSource(
        baseUrl: site.url,
        apiKey: site.apiKey,
      );

      return {
        'traffic_sources': await _getTrafficSources(apiDataSource),
        'popular_content': await _getPopularContent(apiDataSource),
        'user_engagement': await _getUserEngagement(apiDataSource),
      };
    } catch (e) {
       if (e is UseCaseException) {
        rethrow;
      }
      throw UseCaseException(
        message: 'Failed to get advanced analytics: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> areStatsStale(String siteId) async {
    final cachedItem = await CacheManager.get('stats_$siteId');
    if (cachedItem == null) return true;

    try {
        final timestamp = DateTime.parse(cachedItem['timestamp']);
        const expiry = Duration(minutes: 15);
        return DateTime.now().difference(timestamp) > expiry;
    } catch (e) {
        return true;
    }
  }

  Future<Map<String, dynamic>> _getTrafficSources(WPApiDataSource api) async {
    return {};
  }

  Future<Map<String, dynamic>> _getPopularContent(WPApiDataSource api) async {
    return {};
  }

  Future<Map<String, dynamic>> _getUserEngagement(WPApiDataSource api) async {
    return {};
  }
}
