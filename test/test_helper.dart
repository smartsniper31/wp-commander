import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_commander/core/localization/app_localizations.dart';
import 'package:wp_commander/core/router.dart';

Widget createTestWidget({
  required Widget child,
  required List<Override> overrides,
}) {
  // Initialize SharedPreferences for tests
  SharedPreferences.setMockInitialValues({});
  
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      routerConfig: router,
    ),
  );
}
