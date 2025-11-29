import 'package:dio/dio.dart';

import '../../models/api/wp_health_model.dart';
import '../../models/api/wp_stats_model.dart';
import '../../../domain/entities/comment_entity.dart';

class WPApiDataSource {
  final Dio _dio;

  WPApiDataSource({required String baseUrl, required String apiKey}) : _dio = Dio() {
    _dio.options.baseUrl = '$baseUrl/wp-json/wp-commander/v1/';
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
  }

  Future<WPStatsModel> getDashboardStats() async {
    try {
      final response = await _dio.get('stats/dashboard');
      return WPStatsModel.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to get dashboard stats: ${e.message}');
    }
  }

  Future<WPHealthModel> getSiteHealth() async {
    try {
      final response = await _dio.get('health/site');
      return WPHealthModel.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to get site health: ${e.message}');
    }
  }

  Future<bool> validateConnection() async {
    try {
      final response = await _dio.get('connection/validate');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<CommentEntity>> getComments({int page = 1, int perPage = 10}) async {
    try {
      final response = await _dio.get('comments', queryParameters: {
        'page': page,
        'per_page': perPage,
      });
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => CommentEntity.fromJson(json)).toList();
    } on DioError catch (e) {
      throw Exception('Failed to get comments: ${e.message}');
    }
  }

  Future<CommentEntity> getComment(int commentId) async {
    try {
      final response = await _dio.get('comments/$commentId');
      return CommentEntity.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to get comment: ${e.message}');
    }
  }

  Future<bool> deleteComment(int commentId) async {
    try {
      final response = await _dio.delete('comments/$commentId');
      return response.statusCode == 200;
    } on DioError catch (e) {
      throw Exception('Failed to delete comment: ${e.message}');
    }
  }

  Future<CommentEntity> updateComment(CommentEntity comment) async {
    try {
      final response = await _dio.put(
        'comments/${comment.id}',
        data: {
          'content': comment.content,
          'status': comment.status,
        },
      );
      return CommentEntity.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to update comment: ${e.message}');
    }
  }

  Future<bool> approveComment(int commentId) async {
    try {
      final response = await _dio.post('comments/$commentId/approve');
      return response.statusCode == 200;
    } on DioError catch (e) {
      throw Exception('Failed to approve comment: ${e.message}');
    }
  }

  Future<List<CommentEntity>> getPendingComments() async {
    try {
      final response = await _dio.get('comments/pending');
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => CommentEntity.fromJson(json)).toList();
    } on DioError catch (e) {
      throw Exception('Failed to get pending comments: ${e.message}');
    }
  }

  Future<int> getPendingCommentsCount() async {
    try {
      final response = await _dio.get('comments/pending/count');
      return response.data['count'] ?? 0;
    } on DioError catch (e) {
      throw Exception('Failed to get pending comments count: ${e.message}');
    }
  }

  Future<bool> spamComment(int commentId) async {
    try {
      final response = await _dio.post('comments/$commentId/spam');
      return response.statusCode == 200;
    } on DioError catch (e) {
      throw Exception('Failed to spam comment: ${e.message}');
    }
  }
}
