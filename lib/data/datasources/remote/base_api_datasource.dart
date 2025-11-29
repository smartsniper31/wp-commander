import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/utils/connection_helper.dart';

class BaseApiDataSource {
  final String baseUrl;
  final String apiKey;
  final Duration timeout;
  final _log = Logger('BaseApiDataSource');
  final Dio _dio;

  BaseApiDataSource({
    required this.baseUrl,
    required this.apiKey,
    this.timeout = const Duration(seconds: 30),
  }) : _dio = Dio() {
    _dio.options.baseUrl = ApiEndpoints.buildEndpoint(baseUrl, '');
    _dio.options.connectTimeout = timeout;
    _dio.options.receiveTimeout = timeout;
    _dio.options.headers = _headers;
  }

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

    if (kDebugMode) {
      _log.info('🔗 API GET: $baseUrl$endpoint');
    }

    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      throw _handleDioError(e);
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

    if (kDebugMode) {
      _log.info('🔗 API POST: $baseUrl$endpoint');
      _log.info('📦 Body: $body');
    }

    try {
      final response = await _dio.post(
        endpoint,
        data: body,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  // Gestion uniforme des réponses
  Map<String, dynamic> _handleResponse(Response response) {
    if (kDebugMode) {
      _log.info('📡 Response Status: ${response.statusCode}');
      _log.info('📄 Response Body: ${response.data}');
    }

    if (response.data is String) {
      return jsonDecode(response.data);
    }

    return response.data;
  }

  ApiException _handleDioError(DioError e) {
    if (e.type == DioErrorType.connectionTimeout ||
        e.type == DioErrorType.receiveTimeout) {
      return ApiException(
        code: 'TIMEOUT',
        message: 'Request timeout after ${timeout.inSeconds} seconds',
        statusCode: 408,
      );
    }

    if (e.response != null) {
      return ApiException(
        code: e.response?.data?['code'] ?? 'UNKNOWN_ERROR',
        message: e.response?.data?['message'] ?? 'Unknown error occurred',
        statusCode: e.response?.statusCode ?? 0,
      );
    }

    return ApiException(
      code: 'CLIENT_ERROR',
      message: 'Client error: ${e.message}',
      statusCode: 0,
    );
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
