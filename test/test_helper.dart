import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_commander/core/localization/app_localizations.dart';
import 'package:wp_commander/data/datasources/local/app_preferences.dart';
import 'package:wp_commander/data/models/local/cached_data_model.dart';
import 'package:wp_commander/main.dart';

Widget createTestWidget({
  required Widget child,
  required List<Override> overrides,
}) {
  // Initialize SharedPreferences for tests
  SharedPreferences.setMockInitialValues({});

  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      home: child,
    ),
  );
}

Future<Widget> createTestApp({
  List<Override> overrides = const [],
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  // Init Hive
  // Use a temporary directory for Hive in tests to avoid conflicts
  await Hive.initFlutter('test');
  if (!Hive.isAdapterRegistered(CachedDataModelAdapter().typeId)) {
    Hive.registerAdapter(CachedDataModelAdapter());
  }

  // Init AppPreferences
  await AppPreferences.init();

  return ProviderScope(
    overrides: overrides,
    child: const MyApp(),
  );
}
