import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import 'package:wp_commander/core/errors/failures.dart';
import 'package:either_dart/either.dart';
import '../../domain/repositories/stats_repository.dart';
import '../../domain/entities/stats_entity.dart';
import '../datasources/remote/wp_api_datasource.dart';
import '../datasources/local/cache_manager.dart';
import '../adapters/api_adapter.dart';
import '../models/api/wp_stats_model.dart';
import '../../domain/entities/site_entity.dart';
import '../../core/providers/repository_providers.dart';

class StatsRepositoryImpl implements StatsRepository {
  final Ref ref;

  StatsRepositoryImpl(this.ref);

  Future<SiteEntity> _getSiteById(String siteId) async {
    final siteEither = await ref.read(siteRepositoryProvider).getSiteById(siteId);

    return siteEither.fold(
      (failure) =>
          throw Exception("Site not found: $siteId"),
      (site) {
        if (site == null) {
          throw Exception("Site not found: $siteId");
        }
        return site;
      },
    );
  }

  @override
  Future<Either<Failure, StatsEntity>> getStats(String siteId) async {
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

      return Right(statsEntity);
    } catch (e) {
      try {
        return await getCachedStats(siteId);
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, StatsEntity>> getCachedStats(String siteId) async {
    try {
      final cachedData = await CacheManager.getValidData('stats_$siteId');
      if (cachedData != null) {
        final statsModel = WPStatsModel.fromJson(jsonDecode(cachedData));
        return Right(ApiAdapter.statsModelToEntity(statsModel));
      }
      return Right(StatsEntity.empty());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshStats(String siteId) async {
    final result = await getStats(siteId);
    return result.isRight ? const Right(null) : Left(result.left);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAdvancedAnalytics(
      String siteId) async {
    try {
      final site = await _getSiteById(siteId);
      final apiDataSource = WPApiDataSource(
        baseUrl: site.url,
        apiKey: site.apiKey,
      );

      return Right({
        'traffic_sources': await _getTrafficSources(apiDataSource),
        'popular_content': await _getPopularContent(apiDataSource),
        'user_engagement': await _getUserEngagement(apiDataSource),
      });
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get advanced analytics: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> areStatsStale(String siteId) async {
    final cachedItem = await CacheManager.get('stats_$siteId');
    if (cachedItem == null) return const Right(true);

    try {
      final timestamp = DateTime.parse(cachedItem['timestamp']);
      const expiry = Duration(minutes: 15);
      return Right(DateTime.now().difference(timestamp) > expiry);
    } catch (e) {
      return const Right(true);
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
