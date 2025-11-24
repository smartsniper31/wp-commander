import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/stats_repository.dart';
import '../../domain/entities/stats_entity.dart';
import '../datasources/remote/wp_api_datasource.dart';
import '../../presentation/notifiers/sites_notifier.dart';

class StatsRepositoryImpl implements StatsRepository {
  final Ref ref;

  StatsRepositoryImpl(this.ref);

  @override
  Future<StatsEntity> getStats(String siteId) async {
    final site = await ref.read(sitesNotifierProvider.notifier).getSiteById(siteId);
    final dataSource = WPApiDataSource(
      baseUrl: site!.url,
      apiKey: site.apiKey,
    );
    final statsModel = await dataSource.getDashboardStats();
    return StatsEntity(
      totalPosts: statsModel.totalPosts,
      totalPages: statsModel.totalPages,
      totalComments: statsModel.totalComments,
      pendingComments: statsModel.pendingComments,
      totalUsers: statsModel.totalUsers,
      lastUpdated: DateTime.parse(statsModel.lastUpdated),
    );
  }
}
