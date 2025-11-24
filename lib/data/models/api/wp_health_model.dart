class WPHealthModel {
  final String status;
  final int score;
  final List<Map<String, dynamic>> issues;
  final String checkedAt;
  final bool isOnline;
  final double responseTime;
  final String phpVersion;
  final String mysqlVersion;
  final String wordpressVersion;

  WPHealthModel({
    required this.status,
    required this.score,
    required this.issues,
    required this.checkedAt,
    required this.isOnline,
    required this.responseTime,
    required this.phpVersion,
    required this.mysqlVersion,
    required this.wordpressVersion,
  });

  factory WPHealthModel.fromJson(Map<String, dynamic> json) {
    return WPHealthModel(
      status: json['status'] ?? 'unknown',
      score: json['score'] ?? 0,
      issues: List<Map<String, dynamic>>.from(json['issues'] ?? []),
      checkedAt: json['checked_at'] ?? DateTime.now().toIso8601String(),
      isOnline: json['is_online'] ?? false,
      responseTime: (json['response_time'] ?? 0).toDouble(),
      phpVersion: json['php_version'] ?? '',
      mysqlVersion: json['mysql_version'] ?? '',
      wordpressVersion: json['wp_version'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'score': score,
      'issues': issues,
      'checked_at': checkedAt,
      'is_online': isOnline,
      'response_time': responseTime,
      'php_version': phpVersion,
      'mysql_version': mysqlVersion,
      'wp_version': wordpressVersion,
    };
  }
}
