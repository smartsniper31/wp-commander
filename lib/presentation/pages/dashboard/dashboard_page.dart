
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/presentation/notifiers/sites_notifier.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitesAsyncValue = ref.watch(sitesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement add site functionality
            },
          ),
        ],
      ),
      body: sitesAsyncValue.when(
        data: (sites) {
          if (sites.isEmpty) {
            return const Center(
              child: Text('No sites yet. Add one!'),
            );
          }
          return ListView.builder(
            itemCount: sites.length,
            itemBuilder: (context, index) {
              final site = sites[index];
              return ListTile(
                title: Text(site.name),
                subtitle: Text(site.url),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    ref.read(sitesNotifierProvider.notifier).deleteSite(site);
                  },
                ),
                onTap: () {
                  // TODO: Navigate to site details page
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
