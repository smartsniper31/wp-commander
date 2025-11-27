import 'package:flutter/material.dart';
import 'package:wp_commander/presentation/widgets/charts/health_score_chart.dart';

class HealthScoreCard extends StatelessWidget {
  final int score;

  const HealthScoreCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200,
          child: HealthScoreChart(score: score),
        ),
      ),
    );
  }
}
