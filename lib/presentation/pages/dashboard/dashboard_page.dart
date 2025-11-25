import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wp_commander/core/localization/app_localizations.dart';
import 'package:wp_commander/presentation/widgets/animations/fade_in_animation.dart';

import '../../providers/site/site_list_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteAsync = ref.watch(siteListProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('dashboard.title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ],
      ),
      body: siteAsync.when(
        data: (sites) => sites.isEmpty
            ? FadeInAnimation(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_off, size: 80),
                        const SizedBox(height: 20),
                        Text(
                          l10n.translate('dashboard.empty.title'),
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.translate('dashboard.empty.subtitle'),
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(siteListProvider);
                },
                child: ListView.builder(
                  itemCount: sites.length,
                  itemBuilder: (context, index) {
                    final site = sites[index];
                    return ListTile(
                      title: Text(site.name),
                      subtitle: Text(site.url),
                      onTap: () {
                        context.go('/sites/${site.id}');
                      },
                    );
                  },
                ),
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(l10n.translate('dashboard.loading_error')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/add-site');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
