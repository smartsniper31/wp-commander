import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:wp_commander/core/providers/app_providers.dart';
import 'package:wp_commander/core/providers/shared_preferences_provider.dart';
import 'package:wp_commander/core/routing/router.dart';
import 'package:wp_commander/core/theme/theme.dart';
import 'package:wp_commander/data/datasources/local/app_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wp_commander/core/localization/app_localizations.dart';
import 'package:wp_commander/data/models/local/cached_data_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(CachedDataModelAdapter());

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(sharedPreferencesProvider).when(
          data: (prefs) {
            // Initialize AppPreferences with the SharedPreferences instance.
            // This needs to be done before the app runs.
            AppPreferences.init(prefs);
            return const WpCommanderApp();
          },
          loading: () => const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (err, stack) => MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error: $err'),
              ),
            ),
          ),
        );
  }
}

class WpCommanderApp extends ConsumerWidget {
  const WpCommanderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: 'WP Commander',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: router,
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