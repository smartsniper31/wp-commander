import 'package:equatable/equatable.dart';

class HealthIssue extends Equatable {
  final String test;
  final String label;
  final String status;
  final String badge;
  final String description;

  const HealthIssue({
    required this.test,
    required this.label,
    required this.status,
    required this.badge,
    required this.description,
  });

  @override
  List<Object> get props => [test, label, status, badge, description];

  factory HealthIssue.fromJson(Map<String, dynamic> json) {
    return HealthIssue(
      test: json['test'] ?? '',
      label: json['label'] ?? '',
      status: json['status'] ?? '',
      badge: json['badge'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'test': test,
      'label': label,
      'status': status,
      'badge': badge,
      'description': description,
    };
  }
}
