import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wp_commander/core/localization/app_localizations.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/presentation/notifiers/sites_provider.dart';
import 'package:wp_commander/presentation/notifiers/sites_state.dart';
import 'package:wp_commander/presentation/pages/dashboard/dashboard_page.dart';

import '../../mocks.dart';
import '../../test_helper.dart';

void main() {
  late MockSitesNotifier mockNotifier;

  final tSites = [
    SiteEntity(
      id: '1',
      name: 'Test Site 1',
      url: 'https://test1.com',
      apiKey: 'key1',
      createdAt: DateTime.now(),
    ),
  ];

  setUp(() {
    mockNotifier = MockSitesNotifier();
  });

  testWidgets(
      'DashboardPage displays loading indicator when state is initial or loading',
      (WidgetTester tester) async {
    mockNotifier.state = const SitesState.loading();
    final widget = await createTestWidget(
      overrides: [
        sitesProvider.overrideWith(
          (ref) => mockNotifier,
        ),
      ],
      child: const DashboardPage(),
    );
    await tester.pumpWidget(widget);

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('DashboardPage displays a list of sites on loaded state',
      (WidgetTester tester) async {
    mockNotifier.state = SitesState.loaded(sites: tSites);

    final widget = await createTestWidget(
      overrides: [
        sitesProvider.overrideWith(
          (ref) => mockNotifier,
        ),
      ],
      child: const DashboardPage(),
    );
    await tester.pumpWidget(widget);

    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Test Site 1'), findsOneWidget);
  });

  testWidgets('DashboardPage displays empty state when there are no sites',
      (WidgetTester tester) async {
    mockNotifier.state = const SitesState.loaded(sites: []);

    final widget = await createTestWidget(
      overrides: [
        sitesProvider.overrideWith(
          (ref) => mockNotifier,
        ),
      ],
      child: const DashboardPage(),
    );
    await tester.pumpWidget(widget);
    await tester.pump();

    final l10n = AppLocalizations.of(tester.element(find.byType(DashboardPage)));
    expect(find.text(l10n.translate('dashboard.emptyMessage')), findsOneWidget);
  });

  testWidgets('DashboardPage displays error message on failure',
      (WidgetTester tester) async {
    mockNotifier.state = const SitesState.error(message: 'Failed to fetch sites');

    final widget = await createTestWidget(
      overrides: [
        sitesProvider.overrideWith(
          (ref) => mockNotifier,
        ),
      ],
      child: const DashboardPage(),
    );
    await tester.pumpWidget(widget);

    await tester.pump();

    final l10n = AppLocalizations.of(tester.element(find.byType(DashboardPage)));
    expect(find.text(l10n.translate('dashboard.loadingError')), findsOneWidget);
  });
}
