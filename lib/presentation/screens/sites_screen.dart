import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/presentation/providers/site/site_list_provider.dart';
import 'package:wp_commander/presentation/pages/sites/add_site_page.dart';
import 'package:wp_commander/presentation/pages/sites/site_detail_page.dart';
import 'package:wp_commander/presentation/widgets/common/empty_state_widget.dart';
import 'package:wp_commander/presentation/widgets/common/error_retry_widget.dart';
import 'package:wp_commander/presentation/widgets/common/loading_indicator.dart';
import 'package:wp_commander/presentation/widgets/cards/site_card.dart';

class SitesScreen extends ConsumerWidget {
  const SitesScreen({super.key});

  void _navigateToAddSite(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddSitePage()),
    );
  }

  void _navigateToSiteDetail(BuildContext context, String siteId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SiteDetailPage(siteId: siteId)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitesState = ref.watch(sitesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes sites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddSite(context),
          ),
        ],
      ),
      body: sitesState.when(
        initial: () => const LoadingIndicator(message: 'Chargement des sites...'),
        loading: () => const LoadingIndicator(message: 'Chargement des sites...'),
        loaded: (sites) => _buildSitesList(context, sites, ref),
        error: (message) => ErrorRetryWidget(
          title: 'Impossible de charger les sites.',
          description: message,
          onRetry: () => ref.read(sitesProvider.notifier).fetchSites(), message: '',
        ),
      ),
    );
  }

  Widget _buildSitesList(
      BuildContext context, List<SiteEntity> sites, WidgetRef ref) {
    if (sites.isEmpty) {
      return EmptyStateWidget(
        title: 'Aucun site pour le moment.',
        description:
            'Ajoutez votre premier site pour commencer à gérer votre WordPress.',
        icon: Icons.add_to_photos_outlined,
        buttonText: 'Ajouter un site',
        onButtonPressed: () => _navigateToAddSite(context),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(sitesProvider.notifier).fetchSites(),
      child: ListView.builder(
        itemCount: sites.length,
        itemBuilder: (context, index) {
          final site = sites[index];
          return SiteCard(
            site: site,
            onTap: () => _navigateToSiteDetail(context, site.id),
          );
        },
      ),
    );
  }
}
