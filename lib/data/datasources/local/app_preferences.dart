import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static SharedPreferences? _prefs;

  static Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;
  }

  // Thème et apparence
  static bool get isDarkMode {
    return _prefs!.getBool('dark_mode') ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    await _prefs!.setBool('dark_mode', value);
  }

  // Langue
  static String get language {
    return _prefs!.getString('language') ?? 'en';
  }

  static Future<void> setLanguage(String languageCode) async {
    await _prefs!.setString('language', languageCode);
  }

  // Paramètres de cache
  static bool get cacheEnabled {
    return _prefs!.getBool('cache_enabled') ?? true;
  }

  static Future<void> setCacheEnabled(bool value) async {
    await _prefs!.setBool('cache_enabled', value);
  }

  static int get cacheDuration {
    return _prefs!.getInt('cache_duration') ?? 15; // minutes
  }

  static Future<void> setCacheDuration(int minutes) async {
    await _prefs!.setInt('cache_duration', minutes);
  }

  // Notifications
  static bool get healthAlertsEnabled {
    return _prefs!.getBool('health_alerts') ?? true;
  }

  static Future<void> setHealthAlertsEnabled(bool value) async {
    await _prefs!.setBool('health_alerts', value);
  }

  static bool get commentNotificationsEnabled {
    return _prefs!.getBool('comment_notifications') ?? true;
  }

  static Future<void> setCommentNotificationsEnabled(bool value) async {
    await _prefs!.setBool('comment_notifications', value);
  }

  // Sécurité
  static bool get biometricAuthEnabled {
    return _prefs!.getBool('biometric_auth') ?? false;
  }

  static Future<void> setBiometricAuthEnabled(bool value) async {
    await _prefs!.setBool('biometric_auth', value);
  }

  static bool get autoLockEnabled {
    return _prefs!.getBool('auto_lock') ?? true;
  }

  static Future<void> setAutoLockEnabled(bool value) async {
    await _prefs!.setBool('auto_lock', value);
  }

  // Données d'application
  static DateTime? get firstLaunchDate {
    final timestamp = _prefs!.getInt('first_launch');
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  static Future<void> setFirstLaunchDate(DateTime date) async {
    await _prefs!.setInt('first_launch', date.millisecondsSinceEpoch);
  }

  static int get launchCount {
    return _prefs!.getInt('launch_count') ?? 0;
  }

  static Future<void> incrementLaunchCount() async {
    final currentCount = launchCount;
    await _prefs!.setInt('launch_count', currentCount + 1);
  }

  // Méthodes utilitaires
  static Future<void> clearAllPreferences() async {
    await _prefs!.clear();
  }

  static Future<void> resetToDefaults() async {
    await setDarkMode(false);
    await setLanguage('en');
    await setCacheEnabled(true);
    await setCacheDuration(15);
    await setHealthAlertsEnabled(true);
    await setCommentNotificationsEnabled(true);
    await setBiometricAuthEnabled(false);
    await setAutoLockEnabled(true);
  }

  // Export des préférences
  static Map<String, dynamic> exportPreferences() {
    return {
      'dark_mode': isDarkMode,
      'language': language,
      'cache_enabled': cacheEnabled,
      'cache_duration': cacheDuration,
      'health_alerts': healthAlertsEnabled,
      'comment_notifications': commentNotificationsEnabled,
      'biometric_auth': biometricAuthEnabled,
      'auto_lock': autoLockEnabled,
      'first_launch': firstLaunchDate?.toIso8601String(),
      'launch_count': launchCount,
    };
  }
}
