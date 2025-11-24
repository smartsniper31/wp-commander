import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/datasource_providers.dart';
import '../../data/repositories/comments_repository_impl.dart';
import '../../data/repositories/health_repository_impl.dart';
import '../../data/repositories/site_repository_impl.dart';
import '../../data/repositories/stats_repository_impl.dart';
import '../../domain/repositories/comments_repository.dart';
import '../../domain/repositories/health_repository.dart';
import '../../domain/repositories/site_repository.dart';
import '../../domain/repositories/stats_repository.dart';

// Providers pour les repositories
final siteRepositoryProvider = Provider<SiteRepository>((ref) {
  final remoteDataSource = ref.watch(siteRemoteDataSourceProvider);
  final localDataSource = ref.watch(siteLocalDataSourceProvider);
  return SiteRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  final remoteDataSource = ref.watch(statsRemoteDataSourceProvider);
  return StatsRepositoryImpl(remoteDataSource: remoteDataSource);
});

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  final remoteDataSource = ref.watch(healthRemoteDataSourceProvider);
  return HealthRepositoryImpl(remoteDataSource: remoteDataSource);
});

final commentsRepositoryProvider = Provider<CommentsRepository>((ref) {
  final remoteDataSource = ref.watch(commentsRemoteDataSourceProvider);
  return CommentsRepositoryImpl(remoteDataSource: remoteDataSource);
});
