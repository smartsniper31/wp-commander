import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wp_commander/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('Complete app flow - add site and view dashboard', (WidgetTester tester) async {
      // Lancement de l'app
      await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
      await tester.pumpAndSettle();

      // Vérifier l'écran d'accueil
      expect(find.text('Tableau de bord'), findsOneWidget);

      // Naviguer vers l'ajout de site
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Remplir le formulaire
      await tester.enterText(find.bySemanticsLabel('Nom du site'), 'Mon Site Test');
      await tester.enterText(find.bySemanticsLabel('URL du site'), 'https://example.com');
      await tester.enterText(find.bySemanticsLabel('Clé API'), 'test_api_key_123');

      // Soumettre le formulaire
      await tester.tap(find.text('Ajouter le site'));
      await tester.pumpAndSettle();

      // Vérifier le retour au dashboard
      expect(find.text('Mon Site Test'), findsOneWidget);
      expect(find.text('Tableau de bord'), findsOneWidget);
    });
  });
}
