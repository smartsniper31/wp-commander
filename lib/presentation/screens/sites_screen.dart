import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/sites_notifier.dart';

class SitesScreen extends ConsumerWidget {
  const SitesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitesState = ref.watch(sitesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sites'),
      ),
      body: sitesState.when(
        data: (sites) => ListView.builder(
          itemCount: sites.length,
          itemBuilder: (context, index) {
            final site = sites[index];
            return ListTile(
              title: Text(site.name),
              subtitle: Text(site.url),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
