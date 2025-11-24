class WpHealthIssueModel {
  final String issue;
  final String severity;
  final String details;

  WpHealthIssueModel({
    required this.issue,
    required this.severity,
    required this.details,
  });

  factory WpHealthIssueModel.fromJson(Map<String, dynamic> json) {
    return WpHealthIssueModel(
      issue: json['issue'],
      severity: json['severity'],
      details: json['details'],
    );
  }
}
