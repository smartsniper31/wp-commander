import 'package:equatable/equatable.dart';

class HealthIssue extends Equatable {
  final String issue;
  final String description;

  const HealthIssue({required this.issue, required this.description});

  @override
  List<Object> get props => [issue, description];

  factory HealthIssue.fromJson(Map<String, dynamic> json) {
    return HealthIssue(
      issue: json['issue'],
      description: json['description'],
    );
  }
}
