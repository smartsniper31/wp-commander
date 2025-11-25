import '../../domain/entities/health_entity.dart';
import '../../domain/entities/health_issue_entity.dart';
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
    final issues = model.issues.map((issue) => HealthIssue(
      test: issue['test'] ?? '',
      label: issue['label'] ?? '',
      status: issue['status'] ?? '',
      badge: issue['badge']['label'] ?? '',
      description: issue['description'] ?? '',
    )).toList();

    final good = issues.where((i) => i.status == 'good').length;
    final recommended = issues.where((i) => i.status == 'recommended').length;
    final critical = issues.where((i) => i.status == 'critical').length;

    return HealthEntity(
      phpVersion: model.phpVersion,
      mysqlVersion: model.mysqlVersion,
      wordpressVersion: model.wordpressVersion,
      status: model.status,
      good: good,
      recommended: recommended,
      critical: critical,
      issues: issues,
    );
  }
}
