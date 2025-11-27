import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wp_commander/data/models/site_model.dart';

class FakeSiteModel extends Fake implements SiteModel {}

Future<void> testExecutable(FutureOr<void> Function() main) async {
  setUpAll(() {
    // Configuration globale pour tous les tests
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(FakeSiteModel());
  });

  setUp(() {
    // Configuration avant chaque test
  });

  tearDown(() {
    // Nettoyage après chaque test
  });

  await main();
}
