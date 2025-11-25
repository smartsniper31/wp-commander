import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wp_commander/core/performance/performance_monitor.dart';
import 'package:wp_commander/core/utils/logger.dart';

import 'core/providers/app_providers.dart';
import 'core/providers/locale_provider.dart';
import 'core/routers/app_router.dart';
import 'core/themes/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'data/datasources/local/app_preferences.dart';
import 'data/datasources/local/cache_manager.dart';
import 'data/models/local/cached_data_model.dart';
import 'domain/services/notification_service.dart';
import 'presentation/pages/error/initialization_error_page.dart';
import 'domain/services/security_service.dart';
import 'presentation/widgets/common/global_loading_overlay.dart';

void main() async {
  // Désactiver les logs en production
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  try {
    // Initialisation Flutter
    WidgetsFlutterBinding.ensureInitialized();

    // Setup logging
    setupLogging();

    // Initialiser Hive
    await Hive.initFlutter();

    // Enregistrer les adapters Hive
    Hive.registerAdapter(CachedDataModelAdapter());

    await AppPreferences.init();
    await AppPreferences.incrementLaunchCount();
    if (AppPreferences.firstLaunchDate == null) {
      await AppPreferences.setFirstLaunchDate(DateTime.now());
    }

    // Initialiser la sécurité
    const encryptionKey = 'wp_commander_secure_key_2024'; // À externaliser
    SecurityService.initialize(encryptionKey);

    // Create a ProviderContainer to access providers before runApp
    final container = ProviderContainer();

    // Initialiser les notifications
    await container.read(notificationServiceProvider).init();

    // Nettoyer le cache expiré au démarrage
    await CacheManager.cleanExpiredCache();

    // Initialiser le monitoring de performance
    PerformanceMonitor.clearMetrics();

    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
  } catch (e, s) {
    runApp(InitializationErrorPage(error: e, stackTrace: s));
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final locale = ref.watch(localeNotifierProvider);
    final themeMode = ref.watch(themeNotifierProvider);

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
