// ignore_for_file: unused_import

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/presentation/notifiers/sites_provider.dart';
import 'package:collection/collection.dart';
import 'package:wp_commander/presentation/notifiers/sites_state.dart';

// Provider that extracts the raw list of sites from the SitesState.
// This allows other providers to depend on just the list, and not rebuild
// when the state changes from loading to loaded (if the list is the same).
final siteListProvider = Provider<List<SiteEntity>>((ref) {
  final sitesState = ref.watch(sitesProvider);
  return sitesState.maybeWhen(
    loaded: (sites) => sites,
    orElse: () => [],
  );
});

// A provider that returns the count of sites.
final siteCountProvider = Provider<int>((ref) {
  return ref.watch(siteListProvider).length;
});

// A provider that returns the 3 most recent sites for display on a dashboard.
final recentSitesProvider = Provider<List<SiteEntity>>((ref) {
  final sites = ref.watch(siteListProvider);
  // Create a mutable copy before sorting
  final sortedSites = List<SiteEntity>.from(sites);
  sortedSites.sort((a, b) {
    // Handle null createdAt dates
    final dateA = a.createdAt;
    final dateB = b.createdAt;
    return dateB.compareTo(dateA);
  });
  return sortedSites.take(3).toList();
});

// A provider to find a single site by its ID.
final findSiteByIdProvider = Provider.family<SiteEntity?, String>((ref, id) {
  final sites = ref.watch(siteListProvider);
  return sites.firstWhereOrNull((site) => site.id == id);
});
