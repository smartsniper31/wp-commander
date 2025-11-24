import 'package:flutter/foundation.dart';

import '../../../domain/entities/health_entity.dart';

@immutable
class HealthModel extends HealthEntity {
  const HealthModel({
    required super.status,
    required super.phpVersion,
    required super.mysqlVersion,
    required super.wordpressVersion,
  });

  factory HealthModel.fromJson(Map<String, dynamic> json) {
    return HealthModel(
      status: json['status'] ?? 'unknown',
      phpVersion: json['php_version'] ?? 'unknown',
      mysqlVersion: json['mysql_version'] ?? 'unknown',
      wordpressVersion: json['wordpress_version'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'php_version': phpVersion,
      'mysql_version': mysqlVersion,
      'wordpress_version': wordpressVersion,
    };
  }
}
