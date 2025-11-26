import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_commander/data/datasources/local/app_preferences.dart';
import 'package:wp_commander/main.dart';

void main() {
  testWidgets('Initial app load and dashboard display', (WidgetTester tester) async {
    // Set up a mock SharedPreferences instance
    SharedPreferences.setMockInitialValues({});
    await AppPreferences.init(); // Await the async initialization

    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Initial pump to load the app
    await tester.pumpAndSettle();

    // Verify that the dashboard page is displayed
    expect(find.text('Tableau de bord'), findsOneWidget);
  });
}