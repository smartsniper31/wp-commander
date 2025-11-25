import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/presentation/pages/sites/add_site_page.dart';
import 'package:wp_commander/presentation/providers/site/site_list_provider.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitesAsync = ref.watch(siteListProvider);

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
      body: sitesAsync.when(
        data: (sites) => _buildSitesList(context, sites, ref),
        loading: () => const LoadingIndicator(message: 'Chargement des sites...'),
        error: (err, stack) {
          final message = err is Exception ? err.toString() : 'Une erreur inattendue est survenue.';
          return ErrorRetryWidget(
            message: 'Impossible de charger les sites.',
            details: message,
            onRetry: () => ref.refresh(siteListProvider),
          );
        },
      ),
    );
  }

  Widget _buildSitesList(
      BuildContext context, List<SiteEntity> sites, WidgetRef ref) {
    if (sites.isEmpty) {
      return EmptyStateWidget(
        message: 'Aucun site pour le moment.',
        details: 'Ajoutez votre premier site pour commencer à gérer votre WordPress.',
        icon: Icons.add_to_photos_outlined,
        onAction: () => _navigateToAddSite(context),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(siteListProvider),
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
