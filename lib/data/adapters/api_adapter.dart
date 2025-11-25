import '../../domain/entities/health_entity.dart';
import '../../domain/entities/stats_entity.dart';
import '../models/api/wp_health_model.dart';
import '../models/api/wp_stats_model.dart';

class ApiAdapter {
  static StatsEntity statsModelToEntity(WPStatsModel model) {
    return StatsEntity(
      posts: model.posts,
      pages: model.pages,
      comments: model.comments,
      approvedComments: model.approvedComments,
      pending: model.comments - model.approvedComments, // Calculated field
      users: 0, // Not available in this model, default to 0
      lastUpdated: DateTime.now(), // Set to current time on fetch
    );
  }

  static HealthEntity fromWpHealth(WPHealthModel model) {
    return HealthEntity(
      good: model.good,
      recommended: model.recommended,
      critical: model.critical,
      lastUpdated: DateTime.now(),
    );
  }
}
