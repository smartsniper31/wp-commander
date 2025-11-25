import 'package:flutter/foundation.dart';

class PerformanceMonitor {
  static final Map<String, PerformanceMetric> _metrics = {};
  static final List<PerformanceEvent> _events = [];

  static void startTracking(String operationId) {
    _metrics[operationId] = PerformanceMetric(
      id: operationId,
      startTime: DateTime.now(),
      memoryBefore: _getCurrentMemoryUsage(),
    );
  }

  static void endTracking(String operationId) {
    final metric = _metrics[operationId];
    if (metric != null) {
      metric.endTime = DateTime.now();
      metric.memoryAfter = _getCurrentMemoryUsage();
      metric.duration = metric.endTime!.difference(metric.startTime);
      metric.memoryUsed = metric.memoryAfter - metric.memoryBefore;

      _events.add(PerformanceEvent(
        metric: metric,
        timestamp: DateTime.now(),
      ));

      if (kDebugMode) {
        _logPerformance(metric);
      }
    }
  }

  static void _logPerformance(PerformanceMetric metric) {
    debugPrint(\'\'\'
🚀 PERFORMANCE: \${metric.id}
⏱️  Duration: \${metric.duration!.inMilliseconds}ms
💾 Memory: \${metric.memoryUsed} bytes
📊 Timestamp: \${metric.endTime}
\'\'\');
  }

  static int _getCurrentMemoryUsage() {
    // En production, utiliser un package de monitoring mémoire
    return 0;
  }

  static List<PerformanceMetric> getSlowOperations({int thresholdMs = 100}) {
    return _metrics.values
        .where((metric) => metric.duration != null && metric.duration!.inMilliseconds > thresholdMs)
        .toList();
  }

  static void clearMetrics() {
    _metrics.clear();
    _events.clear();
  }
}

class PerformanceMetric {
  final String id;
  final DateTime startTime;
  DateTime? endTime;
  Duration? duration;
  int memoryBefore;
  int memoryAfter;
  int memoryUsed;

  PerformanceMetric({
    required this.id,
    required this.startTime,
    this.endTime,
    this.duration,
    required this.memoryBefore,
    this.memoryAfter = 0,
    this.memoryUsed = 0,
  });
}

class PerformanceEvent {
  final PerformanceMetric metric;
  final DateTime timestamp;

  PerformanceEvent({
    required this.metric,
    required this.timestamp,
  });
}