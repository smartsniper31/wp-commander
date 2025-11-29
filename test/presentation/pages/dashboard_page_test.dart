import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wp_commander/core/localization/app_localizations.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/presentation/notifiers/sites_notifier.dart';
import 'package:wp_commander/presentation/notifiers/sites_provider.dart';
import 'package:wp_commander/presentation/notifiers/sites_state.dart';
import 'package:wp_commander/presentation/pages/dashboard/dashboard_page.dart';

import '../../mocks.dart';
import '../../test_helper.dart';

// Correction : Le FakeNotifier hérite de SitesNotifier
// et appelle le constructeur parent avec les mocks nécessaires.
class FakeSitesNotifier extends SitesNotifier {
  FakeSitesNotifier() : super(
    getSitesUseCase: MockGetSitesUseCase(),
    addSiteUseCase: MockAddSiteUseCase(),
    deleteSiteUseCase: MockDeleteSiteUseCase(),
  );

  // Méthode pour forcer l'état depuis l'extérieur pour les tests
  void setState(SitesState newState) {
    state = newState;
  }
}

void main() {
  final tSites = [
    SiteEntity(
      id: '1',
      name: 'Test Site 1',
      url: 'https://test1.com',
      apiKey: 'key1',
      createdAt: DateTime(2023, 1, 1),
    ),
  ];

  testWidgets(
      'DashboardPage displays loading indicator when state is loading',
      (WidgetTester tester) async {
    // 1. Créer le notifier
    final fakeNotifier = FakeSitesNotifier();
    // 2. Définir son état
    fakeNotifier.setState(const SitesState.loading());

    final widget = await createTestWidget(
      overrides: [
        sitesProvider.overrideWith((ref) => fakeNotifier),
      ],
      child: const DashboardPage(),
    );
    await tester.pumpWidget(widget);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('DashboardPage displays a list of sites on loaded state',
      (WidgetTester tester) async {
    final fakeNotifier = FakeSitesNotifier();
    fakeNotifier.setState(SitesState.loaded(sites: tSites));

    final widget = await createTestWidget(
      overrides: [
        sitesProvider.overrideWith((ref) => fakeNotifier),
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
    final fakeNotifier = FakeSitesNotifier();
    fakeNotifier.setState(const SitesState.loaded(sites: []));

    final widget = await createTestWidget(
      overrides: [
        sitesProvider.overrideWith((ref) => fakeNotifier),
      ],
      child: const DashboardPage(),
    );
    await tester.pumpWidget(widget);
    await tester.pump();

    final BuildContext context = tester.element(find.byType(DashboardPage));
    final l10n = AppLocalizations.of(context);
    expect(find.text(l10n.translate('dashboard.emptyMessage')), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('DashboardPage displays error message on failure',
      (WidgetTester tester) async {
    final fakeNotifier = FakeSitesNotifier();
    fakeNotifier.setState(const SitesState.error(message: 'Failed to fetch sites'));

    final widget = await createTestWidget(
      overrides: [
        sitesProvider.overrideWith((ref) => fakeNotifier),
      ],
      child: const DashboardPage(),
    );
    await tester.pumpWidget(widget);
    await tester.pump();

    final BuildContext context = tester.element(find.byType(DashboardPage));
    final l10n = AppLocalizations.of(context);
    expect(find.text(l10n.translate('dashboard.loadingError')), findsOneWidget);
  });
}
