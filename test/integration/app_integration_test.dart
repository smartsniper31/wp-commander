import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wp_commander/presentation/notifiers/sites_notifier.dart';
import 'package:wp_commander/presentation/notifiers/sites_provider.dart';
import 'package:wp_commander/presentation/notifiers/sites_state.dart';

import '../mocks.dart';
import '../test_helper.dart';

void main() {
  final mockSitesProvider =
      StateNotifierProvider<SitesNotifier, SitesState>(
    (ref) => MockSitesNotifier(),
  );

  testWidgets('Complete app flow - add site and view dashboard',
      (WidgetTester tester) async {
    final testApp = await createTestApp(
      overrides: [
        sitesProvider.overrideWithProvider(mockSitesProvider),
      ],
    );
    await tester.pumpWidget(testApp);

    await tester.pumpAndSettle();

    expect(find.text('WP Commander'), findsOneWidget);

    // ... The rest of the integration test will be implemented later
  });
}
