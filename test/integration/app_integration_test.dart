import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wp_commander/main.dart';
import 'package:wp_commander/presentation/notifiers/sites_provider.dart';

import '../mocks.dart';
import '../test_helper.dart';

void main() {
  testWidgets('Complete app flow - add site and view dashboard',
      (WidgetTester tester) async {
    // 1. Create the test app with the necessary overrides.
    final container = await createTestApp(
      overrides: [
        sitesProvider.overrideWith((ref) => MockSitesNotifier()),
      ],
    );

    // 2. Pump the WpCommanderApp widget with the created container.
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const WpCommanderApp(),
      ),
    );

    // 3. Let the app settle.
    await tester.pumpAndSettle();

    // 4. Verify that the initial state is the Dashboard.
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
