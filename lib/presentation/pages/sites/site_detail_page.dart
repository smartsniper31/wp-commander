import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/site_entity.dart';
import '../../providers/site/site_detail_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_retry_widget.dart';
import '../../widgets/animations/fade_in_animation.dart';
import 'site_detail_view.dart';

class SiteDetailPage extends ConsumerStatefulWidget {
  final String siteId;

  const SiteDetailPage({super.key, required this.siteId});

  @override
  ConsumerState<SiteDetailPage> createState() => _SiteDetailPageState();
}

class _SiteDetailPageState extends ConsumerState<SiteDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(siteDetailProvider(widget.siteId).notifier).loadSite();
    });
  }

  @override
  Widget build(BuildContext context) {
    final siteState = ref.watch(siteDetailProvider(widget.siteId));

    return Scaffold(
      appBar: AppBar(
        title: Text(siteState.asData?.value.name ?? '...'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => ref.read(siteDetailProvider(widget.siteId).notifier).syncSite(),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () { /* TODO: Navigate to edit */ },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _buildBody(siteState),
      ),
    );
  }

  Widget _buildBody(AsyncValue<SiteEntity> siteState) {
    return siteState.when(
      loading: () => const LoadingIndicator(message: 'Chargement du site...'),
      error: (error, stack) => ErrorRetryWidget(
        key: const ValueKey('error'),
        message: 'Erreur de chargement',
        details: error.toString(),
        onRetry: () => ref.read(siteDetailProvider(widget.siteId).notifier).loadSite(),
      ),
      data: (site) => FadeInAnimation(
        key: ValueKey(site.id),
        child: SiteDetailView(site: site),
      ),
    );
  }
}
