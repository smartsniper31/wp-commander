import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = 
      _AppLocalizationsDelegate();
  
  Map<String, String>? _localizedStrings;
  
  Future<bool> load() async {
    final String jsonString = await rootBundle.loadString(
      'assets/translations/${locale.languageCode}.json',
    );
    
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    
    return true;
  }
  
  String translate(String key) {
    return _localizedStrings?[key] ?? key;
  }
  
  // Méthodes helpers pour un accès facile
  String get appTitle => translate('app.title');
  String get appDescription => translate('app.description');
  String get save => translate('common.save');
  String get cancel => translate('common.cancel');
  String get loading => translate('common.loading');
  String get error => translate('common.error');
}

class _AppLocalizationsDelegate 
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }
  
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
