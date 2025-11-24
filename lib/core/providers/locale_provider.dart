import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    return const Locale('en', 'US');
  }

  void setLocale(Locale locale) {
    if (state != locale) {
      state = locale;
    }
  }

  void toggleLanguage() {
    state = state.languageCode == 'en'
        ? const Locale('fr', 'FR')
        : const Locale('en', 'US');
  }

  bool get isEnglish => state.languageCode == 'en';
  bool get isFrench => state.languageCode == 'fr';
}
