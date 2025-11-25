import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/presentation/providers/site/site_list_provider.dart';
import 'package:wp_commander/presentation/widgets/common/empty_state_widget.dart';
import 'package:wp_commander/presentation/widgets/common/error_retry_widget.dart';
import 'package:wp_commander/presentation/widgets/common/loading_indicator.dart';
import 'package:wp_commander/presentation/widgets/cards/site_card.dart';

import '../../domain/entities/site_entity.dart';

class SitesScreen extends ConsumerWidget {
  const SitesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitesAsync = ref.watch(siteListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes sites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: sitesAsync.when(
        data: (sites) => _buildSitesList(context, sites, ref),
        loading: () => const LoadingIndicator(message: 'Chargement des sites...'),
        error: (err, stack) => ErrorRetryWidget(
          message: 'Impossible de charger les sites.',
          details: err.toString(),
          onRetry: () => ref.refresh(siteListProvider),
        ),
      ),
    );
  }

  Widget _buildSitesList(BuildContext context, List<SiteEntity> sites, WidgetRef ref) {
    if (sites.isEmpty) {
      return EmptyStateWidget(
        message: 'Aucun site pour le moment.',
        details: 'Ajoutez votre premier site pour commencer à gérer votre WordPress.',
        icon: Icons.add_to_photos_outlined,
        onAction: () {},
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.refresh(siteListProvider.future),
      child: ListView.builder(
        itemCount: sites.length,
        itemBuilder: (context, index) {
          final site = sites[index];
          return SiteCard(
            site: site,
            onTap: () {},
          );
        },
      ),
    );
  }
}
