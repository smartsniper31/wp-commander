import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/local/app_preferences.dart';

part 'app_providers.g.dart';

@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  bool build() {
    return AppPreferences.isDarkMode;
  }

  void toggleTheme() {
    state = !state;
    AppPreferences.setDarkMode(state);
  }
}
