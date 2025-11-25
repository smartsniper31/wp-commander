import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/site/site_list_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/error_retry_widget.dart';
import '../../widgets/animations/fade_in_animation.dart';
import 'dashboard_view.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Charger les sites au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(siteListProvider.notifier).loadSites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final siteState = ref.watch(siteListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Naviguer vers les paramètres
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _buildBody(siteState),
      ),
      floatingActionButton: siteState.hasSites 
          ? FloatingActionButton(
              onPressed: _navigateToAddSite,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildBody(SiteListState siteState) {
    if (siteState.isLoading && !siteState.hasLoaded) {
      return const LoadingIndicator(message: 'Chargement des sites...');
    }

    if (siteState.hasError) {
      return ErrorRetryWidget(
        key: const ValueKey('error'),
        message: 'Erreur de chargement',
        details: siteState.error,
        onRetry: () => ref.read(siteListProvider.notifier).loadSites(),
      );
    }

    if (siteState.isEmpty) {
      return FadeInAnimation(
        key: const ValueKey('empty'),
        child: EmptyStateWidget(
          title: 'Aucun site configuré',
          description: 'Commencez par ajouter votre premier site WordPress pour suivre ses statistiques et sa santé.',
          icon: Icons.dashboard,
          actions: [
            EmptyStateAction(
              label: 'Ajouter un site',
              onPressed: _navigateToAddSite,
              isPrimary: true,
            ),
          ],
        ),
      );
    }

    return DashboardView(
      key: const ValueKey('data'),
      sites: siteState.sites,
    );
  }

  void _navigateToAddSite() {
    // context.push(AppRoutes.addSite);
  }
}
