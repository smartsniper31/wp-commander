import 'package:flutter/material.dart';
import '../../../domain/entities/site_entity.dart';
import '../../widgets/cards/site_card.dart';

class DashboardView extends StatelessWidget {
  final List<SiteEntity> sites;

  const DashboardView({super.key, required this.sites});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: sites.length,
      itemBuilder: (context, index) {
        return SiteCard(
          site: sites[index],
          index: index,
        );
      },
    );
  }
}
