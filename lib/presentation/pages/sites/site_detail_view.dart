import 'package:flutter/material.dart';
import '../../../domain/entities/site_entity.dart';
import '../../widgets/animations/slide_in_animation.dart';
import '../../widgets/animations/staggered_fade_in_animation.dart';
import '../../widgets/cards/info_card.dart';
import '../../widgets/cards/health_score_card.dart';

class SiteDetailView extends StatelessWidget {
  final SiteEntity site;

  const SiteDetailView({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Section de score de santé
        SlideInAnimation(
          child: HealthScoreCard(score: site.healthScore),
        ),
        const SizedBox(height: 16),
        
        // Section d'informations
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
              value: site.wordpressVersion ?? 'N/A',
              icon: Icons.wordpress,
            ),
            InfoCard(
              title: 'Version PHP',
              value: site.phpVersion ?? 'N/A',
              icon: Icons.code,
            ),
            InfoCard(
              title: 'Dernière synchronisation',
              value: site.lastSync != null ? _formatLastSync(site.lastSync!) : 'Jamais',
              icon: Icons.sync,
            ),
          ],
        ),
        
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
