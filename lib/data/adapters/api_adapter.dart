import 'package:wp_commander/domain/entities/stats_entity.dart';

import '../../domain/entities/health_entity.dart';
import '../models/api/wp_health_model.dart';
import '../models/api/wp_stats_model.dart';

class ApiAdapter {
  // --- Stats --- //

  static StatsEntity fromWpStats(WPStatsModel model) {
    return StatsEntity(
      totalPosts: model.posts,
      totalPages: model.pages,
      totalComments: model.comments,
      pendingComments: model.pendingComments,
      totalUsers: model.users,
      lastUpdated: DateTime.parse(model.lastUpdated),
    );
  }

  // --- Health --- //

  static HealthEntity fromWpHealth(WPHealthModel model) {
    final issues = model.issues.map((issue) {
      return fromWpHealthIssue(WpHealthIssueModel.fromJson(issue));
    }).toList();

    final good = issues.where((i) => i.severity == 'good').length;
    final recommended = issues.where((i) => i.severity == 'recommended').length;
    final critical = issues.where((i) => i.severity == 'critical').length;

    return HealthEntity(
      phpVersion: model.phpVersion,
      mysqlVersion: model.mysqlVersion,
      wordpressVersion: model.wordpressVersion,
      status: model.status,
      issues: issues,
      good: good,
      recommended: recommended,
      critical: critical,
    );
  }

  static HealthIssue fromWpHealthIssue(WpHealthIssueModel model) {
    return HealthIssue(
      issue: model.issue,
      severity: model.severity,
      details: model.details,
    );
  }
}
