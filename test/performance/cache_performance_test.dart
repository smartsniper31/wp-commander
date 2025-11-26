import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_commander/data/datasources/local/cache_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Cache Performance Tests', () {
    test('Cache read/write performance', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      const testData = {'key': 'value', 'number': 42};
      const iterations = 100;

      // Act
      final stopwatch = Stopwatch()..start();
      
      for (var i = 0; i < iterations; i++) {
        await CacheManager.save(
          key: 'perf_test_$i',
          data: jsonEncode(testData),
          dataType: 'test',
          siteId: 'test_site',
        );
      }

      for (var i = 0; i < iterations; i++) {
        await CacheManager.getValidData('perf_test_$i');
      }

      stopwatch.stop();

      // Assert - Doit être rapide (moins de 1 seconde pour 100 opérations)
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });
}