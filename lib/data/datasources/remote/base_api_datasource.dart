import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/utils/connection_helper.dart';

class BaseApiDataSource {
  final String baseUrl;
  final String apiKey;
  final Duration timeout;
  final _log = Logger('BaseApiDataSource');

  BaseApiDataSource({
    required this.baseUrl,
    required this.apiKey,
    this.timeout = const Duration(seconds: 30),
  });

  // Headers communs pour toutes les requêtes
  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-WPC-API-KEY': apiKey,
      'User-Agent': 'WPCommander/1.0.0',
    };
  }

  // Méthode GET générique
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    // Vérifier la connexion internet
    if (!await ConnectionHelper.hasInternetConnection()) {
      throw const ApiException(
        code: 'NO_CONNECTION',
        message: 'No internet connection',
        statusCode: 0,
      );
    }

    final uri = Uri.parse(
      ApiEndpoints.buildEndpoint(baseUrl, endpoint),
    ).replace(queryParameters: queryParameters);

    if (kDebugMode) {
      _log.info('🔗 API GET: $uri');
    }

    try {
      final response = await http
          .get(uri, headers: _headers)
          .timeout(timeout, onTimeout: () {
        throw ApiException(
          code: 'TIMEOUT',
          message: 'Request timeout after ${timeout.inSeconds} seconds',
          statusCode: 408,
        );
      });

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw ApiException(
        code: 'CLIENT_ERROR',
        message: 'Client error: ${e.message}',
        statusCode: 0,
      );
    }
  }

  // Méthode POST générique
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    if (!await ConnectionHelper.hasInternetConnection()) {
      throw const ApiException(
        code: 'NO_CONNECTION',
        message: 'No internet connection',
        statusCode: 0,
      );
    }

    final uri = Uri.parse(
      ApiEndpoints.buildEndpoint(baseUrl, endpoint),
    );

    if (kDebugMode) {
      _log.info('🔗 API POST: $uri');
      _log.info('📦 Body: $body');
    }

    try {
      final response = await http
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw ApiException(
        code: 'CLIENT_ERROR',
        message: 'Client error: ${e.message}',
        statusCode: 0,
      );
    }
  }

  // Gestion uniforme des réponses
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (kDebugMode) {
      _log.info('📡 Response Status: ${response.statusCode}');
      _log.info('📄 Response Body: ${response.body}');
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      case 400:
        throw const ApiException(
          code: 'BAD_REQUEST',
          message: 'Bad request',
          statusCode: 400,
        );
      case 401:
        throw const ApiException(
          code: 'UNAUTHORIZED',
          message: 'Invalid API key',
          statusCode: 401,
        );
      case 403:
        throw const ApiException(
          code: 'FORBIDDEN',
          message: 'Access forbidden',
          statusCode: 403,
        );
      case 404:
        throw const ApiException(
          code: 'NOT_FOUND',
          message: 'Endpoint not found',
          statusCode: 404,
        );
      case 500:
        throw const ApiException(
          code: 'SERVER_ERROR',
          message: 'Internal server error',
          statusCode: 500,
        );
      default:
        throw ApiException(
          code: 'UNKNOWN_ERROR',
          message: 'Unknown error occurred',
          statusCode: response.statusCode,
        );
    }
  }
}

// Exception personnalisée pour les erreurs API
class ApiException implements Exception {
  final String code;
  final String message;
  final int statusCode;

  const ApiException({
    required this.code,
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() {
    return 'ApiException(code: $code, message: $message, statusCode: $statusCode)';
  }

  // Helper pour les erreurs courantes
  bool get isUnauthorized => statusCode == 401;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode >= 500;
  bool get isNetworkError => statusCode == 0;
}
