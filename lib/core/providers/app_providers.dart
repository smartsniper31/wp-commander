import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/app_preferences.dart';

// Ce provider DOIT être surchargé dans la ProviderScope
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider was not overridden');
});

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  // Lit les SharedPreferences de manière synchrone, car elles sont injectées au démarrage.
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;

  // Le constructeur n'accepte plus de SharedPreferences nullable.
  ThemeNotifier(this._prefs)
      : super(AppPreferences.isDarkMode ? ThemeMode.dark : ThemeMode.light);

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newMode;
    AppPreferences.setDarkMode(newMode == ThemeMode.dark);
  }
}
