import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_commander/core/providers/app_providers.dart';
import 'package:wp_commander/core/routers/app_router.dart'; // MODIFIÉ
import 'package:wp_commander/core/theme/theme.dart';
import 'package:wp_commander/data/datasources/local/app_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wp_commander/core/localization/app_localizations.dart';
import 'package:wp_commander/data/models/local/cached_data_model.dart';

Future<void> main() async {
  // Assure que les widgets sont initialisés avant toute autre chose
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(CachedDataModelAdapter());

  // Charge les SharedPreferences et initialise les préférences de l'application
  final prefs = await SharedPreferences.getInstance();
  AppPreferences.init(prefs);

  runApp(
    ProviderScope(
      overrides: [
        // Injecte l'instance de SharedPreferences dans le provider
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const WpCommanderApp(),
    ),
  );
}

class WpCommanderApp extends ConsumerWidget {
  const WpCommanderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final router = ref.watch(goRouterProvider); // MODIFIÉ

    return MaterialApp.router(
      title: 'WP Commander',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: router, // MODIFIÉ
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
