import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wp_commander/core/providers/usecase_providers.dart';
import 'sites_notifier.dart';
import 'sites_state.dart';

final sitesProvider = StateNotifierProvider<SitesNotifier, SitesState>((ref) {
  final getSites = ref.watch(getSitesUseCaseProvider);
  final addSite = ref.watch(addSiteUseCaseProvider);
  final deleteSite = ref.watch(deleteSiteUseCaseProvider);

  return SitesNotifier(
    getSitesUseCase: getSites,
    addSiteUseCase: addSite,
    deleteSiteUseCase: deleteSite,
  );
});
