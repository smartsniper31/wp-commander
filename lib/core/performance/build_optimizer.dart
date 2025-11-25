import 'package:flutter/material.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';

// Widget const pour optimiser les rebuilds
class OptimizedListItem extends StatelessWidget {
  final SiteEntity site;
  final VoidCallback onTap;
  final VoidCallback onSync;

  const OptimizedListItem({
    super.key,
    required this.site,
    required this.onTap,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: _buildSiteIcon(),
        title: _buildTitle(),
        subtitle: _buildSubtitle(),
        trailing: _buildTrailing(),
        onTap: onTap,
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
      child: const Icon(Icons.public, color: Colors.blue, size: 20),
    );
  }

  Widget _buildTitle() {
    return Text(
      site.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      site.cleanUrl,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.grey[600]),
    );
  }

  Widget _buildTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.sync),
          onPressed: onSync,
          tooltip: 'Synchroniser',
        ),
        _buildConnectionStatus(),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: site.isConnected ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        site.isConnected ? 'Connecté' : 'Erreur',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: site.isConnected ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}

// Builder optimisé pour les listes
class OptimizedListViewBuilder extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final EdgeInsetsGeometry? padding;

  const OptimizedListViewBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      addAutomaticKeepAlives: true, // Garde l'état des items
      addRepaintBoundaries: true, // Évite les repaints inutiles
      cacheExtent: 500, // Pré-cache les items
    );
  }
}