import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_commander/core/localization/app_localizations.dart';
import 'package:wp_commander/core/providers/shared_preferences_provider.dart';
import 'package:wp_commander/data/datasources/local/app_preferences.dart';
import 'package:wp_commander/data/models/local/cached_data_model.dart';

Future<Widget> createTestWidget({
  required Widget child,
  List<Override> overrides = const [],
}) async {
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  await AppPreferences.init(sharedPreferences);

  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
      ...overrides,
    ],
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

Future<ProviderContainer> createTestApp({
  List<Override> overrides = const [],
}) async {
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
      ...overrides,
    ],
  );

  WidgetsFlutterBinding.ensureInitialized();

  await AppPreferences.init(sharedPreferences);

  await Hive.initFlutter('test');
  if (!Hive.isAdapterRegistered(CachedDataModelAdapter().typeId)) {
    Hive.registerAdapter(CachedDataModelAdapter());
  }

  return container;
}
