import 'package:equatable/equatable.dart';

import 'health_issue_entity.dart';

class HealthEntity extends Equatable {
  final String phpVersion;
  final String mysqlVersion;
  final String wordpressVersion;
  final String status;
  final int good;
  final int recommended;
  final int critical;
  final List<HealthIssue> issues;

  const HealthEntity({
    required this.phpVersion,
    required this.mysqlVersion,
    required this.wordpressVersion,
    required this.status,
    required this.good,
    required this.recommended,
    required this.critical,
    required this.issues,
  });

  @override
  List<Object?> get props => [
        phpVersion,
        mysqlVersion,
        wordpressVersion,
        status,
        good,
        recommended,
        critical,
        issues,
      ];
}
