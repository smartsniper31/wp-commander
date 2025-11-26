import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/performance/state_optimizer.dart';
import '../../../domain/entities/site_entity.dart';
import '../../notifiers/sites_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/animations/fade_in_animation.dart';
import 'site_detail_view.dart';

class SiteDetailPage extends ConsumerWidget {
  final String siteId;

  const SiteDetailPage({super.key, required this.siteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteAsync = ref.watch(findSiteByIdProvider(siteId));

    return Scaffold(
      appBar: AppBar(
        title: Text(siteAsync?.name ?? '...'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              ref.read(sitesProvider.notifier).syncSite(siteId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () { /* TODO: Navigate to edit */ },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _buildBody(siteAsync),
      ),
    );
  }

  Widget _buildBody(SiteEntity? site) {
    if (site == null) {
      return const LoadingIndicator(message: 'Chargement du site...');
    }

    return FadeInAnimation(
      key: ValueKey(site.id),
      child: SiteDetailView(site: site),
    );
  }
}
