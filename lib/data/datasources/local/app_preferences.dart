import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/site.dart';

/// Une classe utilitaire pour gérer les préférences de l'application et le stockage local simple.
/// Elle doit être initialisée avec `AppPreferences.init()` au démarrage de l'application.
class AppPreferences {
  static SharedPreferences? _prefs;

  // Clé pour stocker la liste des sites dans SharedPreferences
  static const String _sitesKey = 'sites_list';

  /// Initialise le service de préférences. Doit être appelé avant toute autre opération.
  static Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;
  }

  /// Récupère la liste des sites sauvegardés.
  /// Retourne une liste vide si aucun site n'est trouvé ou si les données sont corrompues.
  static List<Site> getSites() {
    if (_prefs == null) return [];

    final sitesJson = _prefs!.getStringList(_sitesKey);
    if (sitesJson == null) {
      return [];
    }

    return sitesJson.map((siteString) {
      try {
        // Décode la chaîne JSON en une Map, puis crée un objet Site
        return Site.fromJson(jsonDecode(siteString) as Map<String, dynamic>);
      } catch (e) {
        // En cas d'erreur de décodage, retourne null (qui sera filtré)
        return null;
      }
    }).whereType<Site>().toList(); // Filtre les éventuelles valeurs null
  }

  /// Sauvegarde la liste complète des sites.
  /// Remplace toutes les données de sites existantes.
  static Future<void> setSites(List<Site> sites) async {
    if (_prefs == null) return;

    final sitesJson = sites.map((site) {
      // Convertit chaque objet Site en une chaîne JSON
      return jsonEncode(site.toJson());
    }).toList();

    await _prefs!.setStringList(_sitesKey, sitesJson);
  }

  // --- Autres préférences ---

  static bool get isDarkMode {
    return _prefs?.getBool('dark_mode') ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool('dark_mode', value);
  }

  static String get language {
    return _prefs?.getString('language') ?? 'en';
  }

  static Future<void> setLanguage(String languageCode) async {
    await _prefs?.setString('language', languageCode);
  }

  // ... (les autres méthodes de préférences que vous aviez déjà) ...

  /// Efface toutes les préférences sauvegardées.
  static Future<void> clearAllPreferences() async {
    await _prefs?.clear();
  }
}
