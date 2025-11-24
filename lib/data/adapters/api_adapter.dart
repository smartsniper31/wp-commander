import 'package:wp_commander/domain/entities/health_issue_entity.dart';
import 'package:wp_commander/domain/entities/stats_entity.dart';

import '../../domain/entities/health_entity.dart';
import '../models/api/wp_health_issue_model.dart';
import '../models/api/wp_health_model.dart';
import '../models/api/wp_stats_model.dart';

class ApiAdapter {
  // --- Stats --- //

  static StatsEntity fromWpStats(WPStatsModel model) {
    return StatsEntity(
      posts: model.totalPosts,
      pages: model.totalPages,
      comments: model.totalComments,
      pending: model.pendingComments,
      users: model.totalUsers,
      lastUpdated: DateTime.now(),
    );
  }

  // --- Health ---

  static HealthEntity fromWpHealth(WPHealthModel model) {
    final issues = model.issues.map((issue) {
      return fromWpHealthIssue(WpHealthIssueModel.fromJson(issue));
    }).toList();

    final good = issues.where((i) => i.description == 'good').length;
    final recommended = issues.where((i) => i.description == 'recommended').length;
    final critical = issues.where((i) => i.description == 'critical').length;

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
      description: model.details,
    );
  }
}
