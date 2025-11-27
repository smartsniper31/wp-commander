import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wp_commander/core/performance/performance_monitor.dart';
import 'package:wp_commander/core/utils/logger.dart';

import 'core/providers/app_providers.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'core/router.dart';
import 'core/themes/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'data/datasources/local/cache_manager.dart';
import 'data/models/local/cached_data_model.dart';
import 'domain/services/notification_service.dart';
import 'presentation/pages/error/initialization_error_page.dart';
import 'domain/services/security_service.dart';
import 'presentation/widgets/common/global_loading_overlay.dart';

void main() async {
  try {
    // Initialisation Flutter
    WidgetsFlutterBinding.ensureInitialized();
    
    // Setup logging
    setupLogging();

    // Initialiser les dépendances asynchrones
    final prefs = await SharedPreferences.getInstance();
    await Hive.initFlutter();

    // Enregistrer les adapters Hive
    Hive.registerAdapter(CachedDataModelAdapter());

    // Initialiser la sécurité
    const encryptionKey = 'wp_commander_secure_key_2024';
    SecurityService.initialize(encryptionKey);
    
    // Nettoyer le cache expiré au démarrage
    await CacheManager.cleanExpiredCache();

    // Initialiser le monitoring de performance
    PerformanceMonitor.clearMetrics();

    runApp(
      ProviderScope(
        overrides: [
          // Surcharger le provider avec l'instance initialisée
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, s) {
    debugPrint('Erreur d\\'initialisation: $e\\n$s');
    runApp(InitializationErrorPage(error: e, stackTrace: s));
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialise le router et les notifiers
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeNotifierProvider);
    final themeMode = ref.watch(themeNotifierProvider);

    // Initialise le service de notification en le "watchant"
    ref.watch(notificationServiceProvider);

    return MaterialApp.router(
      title: 'WP Commander',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return GlobalLoadingOverlay(child: child!);
      },
    );
  }
}
