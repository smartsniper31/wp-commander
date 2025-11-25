import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/presentation/providers/site/site_list_provider.dart';

// Provider optimisé avec sélecteurs
final optimizedSiteListProvider = Provider<List<SiteEntity>>((ref) {
  final state = ref.watch(siteListProvider);
  return state.sites;
});

final optimizedSiteCountProvider = Provider<int>((ref) {
  final sites = ref.watch(optimizedSiteListProvider);
  return sites.length;
});

final optimizedConnectedSitesProvider = Provider<List<SiteEntity>>((ref) {
  final sites = ref.watch(optimizedSiteListProvider);
  return sites.where((site) => site.isConnected).toList();
});

// ConsumerWidget optimisé
class OptimizedConsumer<T> extends ConsumerWidget {
  final ProviderBase<T> provider;
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Widget? child;

  const OptimizedConsumer({
    super.key,
    required this.provider,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider);
    return builder(context, value, child);
  }
}

// Hook pour éviter les rebuilds inutiles
class PerformanceDebouncer {
  Timer? _timer;

  void run(VoidCallback action, {Duration delay = const Duration(milliseconds: 500)}) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}