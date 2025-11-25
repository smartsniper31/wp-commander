import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/core/providers/repository_providers.dart';
import 'package:wp_commander/data/adapters/api_adapter.dart';
import 'package:wp_commander/data/models/api/wp_health_model.dart';
import 'package:wp_commander/domain/entities/health_issue_entity.dart';
import '../../domain/repositories/health_repository.dart';
import '../../domain/entities/health_entity.dart';
import '../datasources/remote/wp_api_datasource.dart';
import '../datasources/local/cache_manager.dart';

class HealthRepositoryImpl implements HealthRepository {
  final Ref ref;

  HealthRepositoryImpl(this.ref);

  Future<WPApiDataSource> _getDataSource(String siteId) async {
    final siteEither = await ref.read(siteRepositoryProvider).getSiteById(siteId);
    if (siteEither.isRight) {
      final site = siteEither.right;
      return WPApiDataSource(
        baseUrl: site.url,
        apiKey: site.apiKey,
      );
    } else {
      throw Exception('Site not found');
    }
  }

  @override
  Future<Either<Failure, HealthEntity>> getSiteHealth(String siteId) async {
    final cacheKey = 'health_$siteId';
    final cachedData = await CacheManager.getValidData(cacheKey);

    if (cachedData != null && cachedData.isNotEmpty) {
      try {
        final healthData = jsonDecode(cachedData);
        return Right(ApiAdapter.fromWpHealth(WPHealthModel.fromJson(healthData)));
      } catch (e) {
        // Les données du cache sont invalides, nous allons les chercher sur le réseau
      }
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
      return Right(ApiAdapter.fromWpHealth(healthData));
    } catch (e) {
      return Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, List<HealthIssue>>> runHealthCheck(String siteId) async {
    try {
      final healthEither = await getSiteHealth(siteId);
      return healthEither.map((health) => health.issues);
    } catch (e) {
      return Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPerformanceMetrics(String siteId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final healthData = await dataSource.getSiteHealth();
      return Right({
        'responseTime': healthData.responseTime,
        'phpVersion': healthData.phpVersion,
        'wordpressVersion': healthData.wordpressVersion,
      });
    } catch (e) {
      return Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, bool>> monitorSiteUptime(String siteId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final healthData = await dataSource.getSiteHealth();
      return Right(healthData.isOnline);
    } catch (e) {
      return Left(Failure.server());
    }
  }
}
