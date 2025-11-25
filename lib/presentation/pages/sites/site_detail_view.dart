import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/domain/entities/health_entity.dart';
import 'package:wp_commander/presentation/providers/site/site_health_provider.dart';
import '../../../domain/entities/site_entity.dart';
import '../../widgets/animations/slide_in_animation.dart';
import '../../widgets/animations/staggered_fade_in_animation.dart';
import '../../widgets/cards/info_card.dart';
import '../../widgets/cards/health_score_card.dart';
import '../../widgets/common/error_retry_widget.dart';
import '../../widgets/common/loading_indicator.dart';

class SiteDetailView extends ConsumerWidget {
  final SiteEntity site;

  const SiteDetailView({super.key, required this.site});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(siteHealthProvider(site.id));

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Section de score de santé et infos dynamiques
        healthAsync.when(
          data: (health) => _buildHealthSection(context, health, site),
          loading: () => const LoadingIndicator(message: 'Analyse de la santé du site...'),
          error: (err, stack) => ErrorRetryWidget(
            message: 'Impossible de charger les informations du site.',
            onRetry: () => ref.refresh(siteHealthProvider(site.id)),
          ),
        ),
        const SizedBox(height: 16),
        
        // Section Actions rapides
        const SizedBox(height: 24),
        Text(
          'Actions rapides',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildQuickActions(context),
      ],
    );
  }

  Widget _buildHealthSection(BuildContext context, HealthEntity health, SiteEntity site) {
    return Column(
      children: [
        SlideInAnimation(
          child: HealthScoreCard(score: health.healthScore.round()),
        ),
        const SizedBox(height: 16),
        StaggeredFadeInAnimation(
          delayBetween: const Duration(milliseconds: 100),
          children: [
            InfoCard(
              title: 'Statut de la connexion',
              value: site.isConnected ? 'Connecté' : 'Erreur',
              icon: site.isConnected ? Icons.check_circle : Icons.error,
              color: site.isConnected ? Colors.green : Colors.red,
            ),
            InfoCard(
              title: 'Version de WordPress',
              value: health.wordpressVersion,
              icon: Icons.wordpress,
            ),
            InfoCard(
              title: 'Version PHP',
              value: health.phpVersion,
              icon: Icons.code,
            ),
            InfoCard(
              title: 'Dernière synchronisation',
              value: site.lastSync != null ? _formatLastSync(site.lastSync!) : 'Jamais',
              icon: Icons.sync,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildActionCard(context, 'Gérer les articles', Icons.article, () {}),
        _buildActionCard(context, 'Gérer les pages', Icons.pages, () {}),
        _buildActionCard(context, 'Modérer les commentaires', Icons.comment, () {}),
        _buildActionCard(context, 'Voir la santé du site', Icons.health_and_safety, () {}),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastSync(DateTime lastSync) {
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    
    if (difference.inMinutes < 1) return 'À l\'instant';
    if (difference.inHours < 1) return 'Il y a ${difference.inMinutes} minutes';
    if (difference.inDays < 1) return 'Il y a ${difference.inHours} heures';
    if (difference.inDays < 7) return 'Il y a ${difference.inDays} jours';
    
    return 'Le ${lastSync.day}/${lastSync.month}/${lastSync.year}';
  }
}
