import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wp_commander/data/datasources/local/app_preferences.dart';

import 'package:wp_commander/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Set up a mock SharedPreferences instance
    await AppPreferences.init();

    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that the home page is displayed
    expect(find.text('Sites'), findsOneWidget);
  });
}
