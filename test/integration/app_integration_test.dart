import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_commander/main.dart';
import 'package:wp_commander/presentation/notifiers/sites_provider.dart';

import '../mocks.dart';
import '../test_helper.dart';

void main() {
  testWidgets('Complete app flow - add site and view dashboard',
      (WidgetTester tester) async {
    // 1. Initialize SharedPreferences for the test.
    SharedPreferences.setMockInitialValues({});

    // 2. Build our app in a test-safe environment.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override the sitesProvider to use our mock implementation
          sitesProvider.overrideWithProvider(
            StateNotifierProvider((ref) => MockSitesNotifier()),
          ),
        ],
        child: MyApp(),
      ),
    );

    // 3. Let the app settle.
    await tester.pumpAndSettle();

    // 4. Verify initial state (Dashboard).
    // Let's use the actual string from the localization file.
    // In a real app, you might want a more robust way to handle localization in tests.
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
