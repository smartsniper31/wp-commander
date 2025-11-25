import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class SecurityService {
  static final _iv = IV.fromLength(16);
  static late Encrypter _encrypter;

  // Initialiser le service de sécurité
  static void initialize(String encryptionKey) {
    final key = Key.fromUtf8(_padKey(encryptionKey));
    _encrypter = Encrypter(AES(key));
  }

  // Chiffrer une chaîne de caractères
  static String encrypt(String plainText) {
    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      throw SecurityException('Erreur lors du chiffrement: ${e.toString()}');
    }
  }

  // Déchiffrer une chaîne de caractères
  static String decrypt(String encryptedText) {
    try {
      final encrypted = Encrypted.fromBase64(encryptedText);
      final decrypted = _encrypter.decrypt(encrypted, iv: _iv);
      return decrypted;
    } catch (e) {
      throw SecurityException('Erreur lors du déchiffrement: ${e.toString()}');
    }
  }

  // Chiffrer les données sensibles d'un site
  static Map<String, String> encryptSiteData({
    required String apiKey,
    required String siteName,
    required String url,
  }) {
    return {
      'encrypted_api_key': encrypt(apiKey),
      'encrypted_site_name': encrypt(siteName),
      'encrypted_url': encrypt(url),
      'encryption_timestamp': DateTime.now().toIso8601String(),
    };
  }

  // Déchiffrer les données d'un site
  static SiteDecryptedData decryptSiteData(Map<String, dynamic> encryptedData) {
    try {
      return SiteDecryptedData(
        apiKey: decrypt(encryptedData['encrypted_api_key'] as String),
        siteName: decrypt(encryptedData['encrypted_site_name'] as String),
        url: decrypt(encryptedData['encrypted_url'] as String),
      );
    } catch (e) {
      throw const SecurityException('Erreur lors du déchiffrement des données du site');
    }
  }

  // Générer un hash pour les données
  static String generateHash(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Valider l'intégrité des données
  static bool validateDataIntegrity(String data, String expectedHash) {
    return generateHash(data) == expectedHash;
  }

  // Nettoyer les données sensibles de la mémoire
  static void cleanSensitiveData(String data) {
    // Overwrite the data in memory (conceptuel - Dart a un garbage collector)
    // En pratique, éviter de stocker les données sensibles trop longtemps
  }

  // Helper pour pad la clé de chiffrement
  static String _padKey(String key) {
    const requiredLength = 32;
    if (key.length == requiredLength) return key;

    if (key.length > requiredLength) {
      return key.substring(0, requiredLength);
    }

    return key.padRight(requiredLength, '0');
  }
}

class SiteDecryptedData {
  final String apiKey;
  final String siteName;
  final String url;

  const SiteDecryptedData({
    required this.apiKey,
    required this.siteName,
    required this.url,
  });
}

class SecurityException implements Exception {
  final String message;

  const SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}