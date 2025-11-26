import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/sites/add_site_usecase.dart';
import '../../../domain/usecases/sites/delete_site_usecase.dart';
import '../../../domain/usecases/sites/get_sites_usecase.dart';
import '../../../domain/usecases/sites/update_site_usecase.dart';
import 'sites_notifier.dart';
import 'sites_state.dart';

final sitesProvider = StateNotifierProvider<SitesNotifier, SitesState>((ref) {
  final getSites = ref.watch(getSitesUseCaseProvider);
  final addSite = ref.watch(addSiteUseCaseProvider);
  final updateSite = ref.watch(updateSiteUseCaseProvider);
  final deleteSite = ref.watch(deleteSiteUseCaseProvider);

  return SitesNotifier(
    getSitesUseCase: getSites,
    addSiteUseCase: addSite,
    updateSiteUseCase: updateSite,
    deleteSiteUseCase: deleteSite,
  )..loadSites();
});
