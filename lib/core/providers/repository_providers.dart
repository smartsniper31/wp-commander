import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:wp_commander/data/datasources/comments_remote_datasource.dart';
import 'package:wp_commander/data/datasources/datasource_providers.dart';
import 'package:wp_commander/data/datasources/site_remote_datasource.dart';

import '../../data/repositories/comments_repository_impl.dart';
import '../../data/repositories/health_repository_impl.dart';
import '../../data/repositories/site_repository_impl.dart';
import '../../data/repositories/stats_repository_impl.dart';
import '../../domain/repositories/comments_repository.dart';
import '../../domain/repositories/health_repository.dart';
import '../../domain/repositories/site_repository.dart';
import '../../domain/repositories/stats_repository.dart';

final siteRepositoryProvider = Provider<SiteRepository>((ref) {
  return SiteRepositoryImpl(
    localDataSource: ref.watch(siteLocalDataSourceProvider),
    remoteDataSource: SiteRemoteDataSourceImpl(client: http.Client()),
  );
});

final commentsRepositoryProvider = Provider<CommentsRepository>((ref) {
  return CommentsRepositoryImpl(
    remoteDataSource: CommentsRemoteDataSourceImpl(),
    siteLocalDataSource: ref.watch(siteLocalDataSourceProvider),
  );
});

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepositoryImpl(ref);
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepositoryImpl(ref);
});
