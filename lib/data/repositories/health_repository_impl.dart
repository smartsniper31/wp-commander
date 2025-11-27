import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/errors/exceptions.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/data/adapters/api_adapter.dart';
import 'package:wp_commander/data/models/api/wp_health_model.dart';
import 'package:wp_commander/domain/entities/health_issue_entity.dart';
import '../../core/providers/repository_providers.dart';
import '../../domain/entities/health_entity.dart';
import '../../domain/repositories/health_repository.dart';
import '../datasources/local/cache_manager.dart';
import '../datasources/remote/wp_api_datasource.dart';

class HealthRepositoryImpl implements HealthRepository {
  final Ref ref;

  HealthRepositoryImpl(this.ref);

  Future<WPApiDataSource> _getDataSource(String siteId) async {
    final siteRepository = ref.read(siteRepositoryProvider);
    final siteEither = await siteRepository.getSiteById(siteId);

    return siteEither.fold(
      (failure) {
        String message = 'Failed to retrieve site.';
        if (failure is ServerFailure) {
          message = failure.message;
        } else if (failure is CacheFailure) {
          message = failure.message;
        }
        throw UseCaseException(message: message);
      },
      (site) {
        if (site == null) {
          throw UseCaseException(message: 'Site not found with ID: $siteId');
        }
        return WPApiDataSource(
          baseUrl: site.url,
          apiKey: site.apiKey,
        );
      },
    );
  }

  @override
  Future<Either<Failure, HealthEntity>> getSiteHealth(String siteId) async {
    final cacheKey = 'health_$siteId';
    try {
      final cachedData = await CacheManager.getValidData(cacheKey);
      if (cachedData != null && cachedData.isNotEmpty) {
        final healthData = jsonDecode(cachedData);
        return Right(
            ApiAdapter.fromWpHealth(WPHealthModel.fromJson(healthData)));
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
      return Right(ApiAdapter.fromWpHealth(healthData));
    } on UseCaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(
          ServerFailure(message: 'Failed to get site health: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<HealthIssue>>> runHealthCheck(
      String siteId) async {
    final healthResult = await getSiteHealth(siteId);
    return healthResult.map((health) => health.issues);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPerformanceMetrics(
      String siteId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final healthData = await dataSource.getSiteHealth();
      return Right({
        'responseTime': healthData.responseTime,
        'phpVersion': healthData.phpVersion,
        'wordpressVersion': healthData.wordpressVersion,
      });
    } on UseCaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
          message: 'Failed to get performance metrics: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> monitorSiteUptime(String siteId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final healthData = await dataSource.getSiteHealth();
      return Right(healthData.isOnline);
    } on UseCaseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
          message: 'Failed to monitor site uptime: ${e.toString()}'));
    }
  }
}
