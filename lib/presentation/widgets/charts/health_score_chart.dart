import 'dart:math' as math;

import 'package:flutter/material.dart';

class HealthScoreChart extends StatefulWidget {
  final int score;
  final Duration animationDuration;

  const HealthScoreChart({
    super.key,
    required this.score,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<HealthScoreChart> createState() => _HealthScoreChartState();
}

class _HealthScoreChartState extends State<HealthScoreChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = Tween<double>(begin: 0, end: widget.score / 100).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant HealthScoreChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(begin: oldWidget.score / 100, end: widget.score / 100).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOutCubic,
        ),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _HealthScorePainter(
            percentage: _animation.value,
            score: (widget.score * _animation.value * 100).toInt(),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(widget.score * _animation.value).round()}% ',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getColorForScore((widget.score * _animation.value).round()),
                      ),
                ),
                Text(
                  'Score de santé',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getColorForScore(int score) {
    if (score >= 85) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}

class _HealthScorePainter extends CustomPainter {
  final double percentage;
  final int score;

  _HealthScorePainter({required this.percentage, required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - 10;
    const strokeWidth = 12.0;

    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Foreground arc
    final foregroundPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          _getColorForScore(0),
          _getColorForScore(50),
          _getColorForScore(100),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: const GradientRotation(math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percentage,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HealthScorePainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.score != score;
  }

  Color _getColorForScore(int score) {
    if (score >= 85) return Colors.green.shade400;
    if (score >= 60) return Colors.orange.shade400;
    return Colors.red.shade400;
  }
}
