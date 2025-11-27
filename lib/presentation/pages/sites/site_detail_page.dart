import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SiteDetailPage extends ConsumerWidget {
  final String siteId;

  const SiteDetailPage({super.key, required this.siteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Site Details'),
      ),
      body: Center(
        child: Text('Details for site $siteId'),
      ),
    );
  }
}
