import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/presentation/pages/dashboard/dashboard_page.dart';
import 'package:wp_commander/presentation/providers/site/site_list_provider.dart';

void main() {
  testWidgets('DashboardPage displays loading indicator initially', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    // Act & Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('DashboardPage displays empty state when no sites', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          siteListProvider.overrideWith(() => SiteListNotifier()),
        ],
        child: const MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    // Override the build method of SiteListNotifier to return an empty list
    final container = ProviderContainer(
      overrides: [
        siteListProvider.overrideWith((ref) =>
            SiteListNotifier()..state = AsyncValue.data([])),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Aucun site configuré'), findsOneWidget);
  });

  testWidgets('DashboardPage displays sites list when sites exist', (WidgetTester tester) async {
    // Arrange
    final mockSites = [
      SiteEntity(
        id: '1',
        name: 'Test Site 1',
        url: 'https://site1.com',
        apiKey: 'key1',
        createdAt: DateTime.now(),
      ),
      SiteEntity(
        id: '2',
        name: 'Test Site 2',
        url: 'https://site2.com',
        apiKey: 'key2',
        createdAt: DateTime.now(),
      ),
    ];

    final container = ProviderContainer(
      overrides: [
        siteListProvider.overrideWith((ref) =>
            SiteListNotifier()..state = AsyncValue.data(mockSites)),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Test Site 1'), findsOneWidget);
    expect(find.text('Test Site 2'), findsOneWidget);
  });
}