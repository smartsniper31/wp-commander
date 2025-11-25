import 'package:flutter/foundation.dart';

import '../../../domain/entities/health_entity.dart';
import '../../../domain/entities/health_issue_entity.dart';

@immutable
class HealthModel extends HealthEntity {
  const HealthModel({
    required super.status,
    required super.phpVersion,
    required super.mysqlVersion,
    required super.wordpressVersion,
    required super.good,
    required super.recommended,
    required super.critical,
    required super.issues,
  });

  factory HealthModel.fromJson(Map<String, dynamic> json) {
    return HealthModel(
      status: json['status'] ?? 'unknown',
      phpVersion: json['php_version'] ?? 'unknown',
      mysqlVersion: json['mysql_version'] ?? 'unknown',
      wordpressVersion: json['wordpress_version'] ?? 'unknown',
      good: json['good'] ?? 0,
      recommended: json['recommended'] ?? 0,
      critical: json['critical'] ?? 0,
      issues: (json['issues'] as List?)
              ?.map((i) => HealthIssue.fromJson(i))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'php_version': phpVersion,
      'mysql_version': mysqlVersion,
      'wordpress_version': wordpressVersion,
      'good': good,
      'recommended': recommended,
      'critical': critical,
      'issues': issues.map((i) => i.toJson()).toList(),
    };
  }
}
