import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() main) async {
  setUpAll(() {
    // Configuration globale pour tous les tests
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    // Configuration avant chaque test
  });

  tearDown(() {
    // Nettoyage après chaque test
  });

  await main();
}
