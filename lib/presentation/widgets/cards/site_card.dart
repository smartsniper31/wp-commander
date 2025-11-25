import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/site_entity.dart';
import '../common/animated_card.dart';

class SiteCard extends ConsumerWidget {
  final SiteEntity site;
  final int index;

  const SiteCard({super.key, required this.site, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AnimatedCard(
      index: index,
      child: InkWell(
        onTap: () => _navigateToSiteDetail(context, site),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec nom et statut
              Row(
                children: [
                  _buildSiteIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          site.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          site.url, // Correction: cleanUrl -> url
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildConnectionStatus(),
                ],
              ),
              const SizedBox(height: 12),

              // Statistiques rapides
              _buildQuickStats(),

              // Actions rapides
              const SizedBox(height: 12),
              _buildQuickActions(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSiteIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.public,
        color: Colors.blue,
        size: 20,
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: site.isConnected ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            site.isConnected ? Icons.check_circle : Icons.error,
            size: 12,
            color: site.isConnected ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            site.isConnected ? 'Connecté' : 'Erreur',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: site.isConnected ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    // This should be updated with real data from StatsEntity
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(Icons.article, 'Articles', '-'),
        _buildStatItem(Icons.comment, 'Commentaires', '-'),
        _buildStatItem(Icons.health_and_safety, 'Santé', '-'),
        _buildStatItem(Icons.update, 'Dernière synchro', site.lastSync != null
            ? _formatLastSync(site.lastSync!)
            : 'Jamais'),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _syncSite(ref),
            icon: const Icon(Icons.sync, size: 16),
            label: const Text('Synchroniser'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton.icon(
            onPressed: () => _navigateToSiteDetail(context, site),
            icon: const Icon(Icons.dashboard, size: 16),
            label: const Text('Détails'),
          ),
        ),
      ],
    );
  }

  String _formatLastSync(DateTime lastSync) {
    final now = DateTime.now();
    final difference = now.difference(lastSync);

    if (difference.inMinutes < 1) return 'À l\'instant';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inDays < 1) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}j';

    return '${lastSync.day}/${lastSync.month}';
  }

  void _navigateToSiteDetail(BuildContext context, SiteEntity site) {
    // AppRouter.router.push('${AppRoutes.siteDetail}?id=${site.id}');
  }

  void _syncSite(WidgetRef ref) {
    // ref.read(siteListProvider.notifier).syncSite(site.id);
  }
}
