import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/core/providers/usecase_providers.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/domain/usecases/sites/get_sites_usecase.dart';
import 'package:wp_commander/presentation/pages/dashboard/dashboard_page.dart';

// Mock GetSitesUseCase with mocktail
class MockGetSitesUseCase extends Mock implements GetSitesUseCase {}

void main() {
  late MockGetSitesUseCase mockGetSitesUseCase;

  setUp(() {
    mockGetSitesUseCase = MockGetSitesUseCase();
  });

  // Helper to pump the widget with necessary providers
  Future<void> pumpDashboardPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // The provider is now correctly referenced from usecase_providers
          getSitesUseCaseProvider.overrideWithValue(mockGetSitesUseCase),
        ],
        child: const MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );
  }

  final tSites = [
    SiteEntity(id: '1', name: 'Test Site 1', url: 'http://site1.com', apiKey: 'key1', createdAt: DateTime.now()),
    SiteEntity(id: '2', name: 'Test Site 2', url: 'http://site2.com', apiKey: 'key2', createdAt: DateTime.now()),
  ];

  testWidgets('DashboardPage displays loading indicator then the list of sites', (WidgetTester tester) async {
    // Arrange
    when(() => mockGetSitesUseCase.execute()).thenAnswer((_) async => Right(tSites));

    // Act
    await pumpDashboardPage(tester);

    // Assert initial state (loading)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Act again to settle the UI after future completes
    await tester.pumpAndSettle();

    // Assert final state (loaded)
    expect(find.text('Test Site 1'), findsOneWidget);
    expect(find.text('Test Site 2'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('DashboardPage displays empty state when there are no sites', (WidgetTester tester) async {
    // Arrange
    when(() => mockGetSitesUseCase.execute()).thenAnswer((_) async => const Right([]));

    // Act
    await pumpDashboardPage(tester);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Aucun site configuré'), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('DashboardPage displays error message on failure', (WidgetTester tester) async {
    // Arrange
    const errorMessage = 'Failed to fetch sites';
    when(() => mockGetSitesUseCase.execute()).thenAnswer((_) async => const Left(CacheFailure(message: errorMessage)));

    // Act
    await pumpDashboardPage(tester);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text(errorMessage), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
