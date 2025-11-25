import 'package:flutter/material.dart';
import 'package:wp_commander/domain/value_objects.dart';

class HealthScoreVO extends ValueObject<int> {
  @override
  final int value;

  @override
  final String? error;

  const HealthScoreVO._(this.value, {this.error});

  factory HealthScoreVO.create(int input) {
    if (input < 0 || input > 100) {
      return HealthScoreVO._(input, error: 'Score de santé invalide');
    }

    return HealthScoreVO._(input);
  }

  @override
  bool get isValid => error == null;

  Color get color {
    if (value >= 80) {
      return Colors.green;
    }
    if (value >= 50) {
      return Colors.orange;
    }
    return Colors.red;
  }

  String get description {
    if (value >= 90) {
      return 'Excellent';
    }
    if (value >= 80) {
      return 'Bon';
    }
    if (value >= 50) {
      return 'Moyen';
    }
    if (value >= 30) {
      return 'Faible';
    }
    return 'Critique';
  }

  @override
  List<Object?> get props => [value, error];
}
