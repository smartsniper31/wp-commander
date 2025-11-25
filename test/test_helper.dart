import 'package:flutter_test/flutter_test.dart';
import 'package:wp_commander/domain/usecases/base_usecase.dart';

// Configuration globale pour les tests
void initTestConfig() {
  // Configuration des timeouts
  setUpAll(() {
    // Désactiver les animations pendant les tests
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    // Reset entre chaque test
  });

  tearDown(() {
    // Nettoyage après chaque test
  });
}

// Helper methods pour les tests
Matcher isUseCaseError(String message) {
  return predicate((dynamic error) {
    return error is UseCaseException && error.message.contains(message);
  });
}
