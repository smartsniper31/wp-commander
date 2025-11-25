import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/api/wp_stats_model.dart';
import '../../../core/errors/exceptions.dart';

class WPApiDataSource {
  final String baseUrl;
  final String apiKey;
  final http.Client client;

  WPApiDataSource({
    required this.baseUrl,
    required this.apiKey,
    http.Client? client,
  }) : client = client ?? http.Client();

  Uri _buildUrl(String endpoint) {
    return Uri.parse('$baseUrl/wp-json/wp-commander/v1/$endpoint');
  }

  Map<String, String> _getHeaders() => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

  Future<WPStatsModel> getDashboardStats() async {
    final response = await client.get(
      _buildUrl('stats/dashboard'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return WPStatsModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to load dashboard stats', code: response.statusCode.toString());
    }
  }

  Future<bool> validateConnection() async {
    final response = await client.get(
      Uri.parse('$baseUrl/wp-json/wp/v2/posts'),
      headers: _getHeaders(),
    );

    return response.statusCode == 200;
  }
}
