import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/presentation/providers/site/site_list_provider.dart';

// Provider optimisé avec sélecteurs
final optimizedSiteListProvider = Provider<List<SiteEntity>>((ref) {
  final state = ref.watch(siteListProvider);
  return state.asData?.value ?? [];
});

final optimizedSiteCountProvider = Provider<int>((ref) {
  final sites = ref.watch(optimizedSiteListProvider);
  return sites.length;
});
