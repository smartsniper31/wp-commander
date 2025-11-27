import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/api/wp_health_model.dart';
import '../../models/api/wp_stats_model.dart';
import '../../../domain/entities/comment_entity.dart';

class WPApiDataSource {
  final String baseUrl;
  final String apiKey;
  final http.Client client;

  WPApiDataSource({
    required this.baseUrl,
    required this.apiKey,
    http.Client? client,
  }) : client = client ?? http.Client();

  Uri _buildUrl(String endpoint, {Map<String, String>? queryParams}) {
    var uri = Uri.parse('$baseUrl/wp-json/wp-commander/v1/$endpoint');
    if (queryParams != null) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
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
      throw Exception('Failed to get dashboard stats');
    }
  }

  Future<WPHealthModel> getSiteHealth() async {
    final response = await client.get(
      _buildUrl('health/site'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return WPHealthModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get site health');
    }
  }

  Future<bool> validateConnection() async {
    try {
      final response = await client.get(
        _buildUrl('connection/validate'),
        headers: _getHeaders(),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<CommentEntity>> getComments({int page = 1, int perPage = 10}) async {
    final response = await client.get(
      _buildUrl('comments', queryParams: {
        'page': page.toString(),
        'per_page': perPage.toString(),
      }),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommentEntity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get comments');
    }
  }

  Future<CommentEntity> getComment(int commentId) async {
    final response = await client.get(
      _buildUrl('comments/$commentId'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return CommentEntity.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get comment');
    }
  }

  Future<bool> deleteComment(int commentId) async {
    final response = await client.delete(
      _buildUrl('comments/$commentId'),
      headers: _getHeaders(),
    );
    return response.statusCode == 200;
  }

  Future<CommentEntity> updateComment(CommentEntity comment) async {
    final response = await client.put(
      _buildUrl('comments/${comment.id}'),
      headers: _getHeaders(),
      body: json.encode({
        'content': comment.content,
        'status': comment.status,
      }),
    );

    if (response.statusCode == 200) {
      return CommentEntity.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update comment');
    }
  }

  Future<bool> approveComment(int commentId) async {
    final response = await client.post(
      _buildUrl('comments/$commentId/approve'),
      headers: _getHeaders(),
    );
    return response.statusCode == 200;
  }

  Future<List<CommentEntity>> getPendingComments() async {
    final response = await client.get(
      _buildUrl('comments/pending'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommentEntity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get pending comments');
    }
  }

  Future<int> getPendingCommentsCount() async {
    final response = await client.get(
      _buildUrl('comments/pending/count'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['count'] ?? 0;
    } else {
      throw Exception('Failed to get pending comments count');
    }
  }

  Future<bool> spamComment(int commentId) async {
    final response = await client.post(
      _buildUrl('comments/$commentId/spam'),
      headers: _getHeaders(),
    );
    return response.statusCode == 200;
  }
}
