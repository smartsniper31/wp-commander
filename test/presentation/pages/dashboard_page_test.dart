import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/presentation/notifiers/sites_notifier.dart';
import 'package:wp_commander/presentation/notifiers/sites_provider.dart';
import 'package:wp_commander/presentation/notifiers/sites_state.dart';
import 'package:wp_commander/presentation/pages/dashboard/dashboard_page.dart';

import '../../mocks.dart';
import '../../test_helper.dart';

void main() {
  final mockSitesProvider = StateNotifierProvider<SitesNotifier, SitesState>(
    (ref) => MockSitesNotifier(),
  );

  final List<SiteEntity> tSites = [
    SiteEntity(
      id: '1',
      name: 'Test Site 1',
      url: 'https://test1.com',
      apiKey: 'key1',
      createdAt: DateTime.now(),
    ),
  ];

  testWidgets(
      'DashboardPage displays loading indicator when state is initial or loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          sitesProvider.overrideWithProvider(mockSitesProvider),
        ],
        child: const DashboardPage(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('DashboardPage displays a list of sites on loaded state',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          sitesProvider.overrideWithProvider(mockSitesProvider),
        ],
        child: const DashboardPage(),
      ),
    );

    final notifier =
        ProviderScope.containerOf(tester.element(find.byType(DashboardPage)))
            .read(mockSitesProvider.notifier);
    (notifier as MockSitesNotifier).state = SitesState.loaded(sites: tSites);

    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Test Site 1'), findsOneWidget);
  });

  testWidgets('DashboardPage displays empty state when there are no sites',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          sitesProvider.overrideWithProvider(mockSitesProvider),
        ],
        child: const DashboardPage(),
      ),
    );

    final notifier =
        ProviderScope.containerOf(tester.element(find.byType(DashboardPage)))
            .read(mockSitesProvider.notifier);
    (notifier as MockSitesNotifier).state = const SitesState.loaded(sites: []);

    await tester.pump();

    expect(find.text('Aucun site configuré'), findsOneWidget);
  });

  testWidgets('DashboardPage displays error message on failure',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          sitesProvider.overrideWithProvider(mockSitesProvider),
        ],
        child: const DashboardPage(),
      ),
    );

    final notifier =
        ProviderScope.containerOf(tester.element(find.byType(DashboardPage)))
            .read(mockSitesProvider.notifier);
    (notifier as MockSitesNotifier).state =
        const SitesState.error(message: 'Failed to fetch sites');

    await tester.pump();

    expect(find.text('Failed to fetch sites'), findsOneWidget);
  });
}
