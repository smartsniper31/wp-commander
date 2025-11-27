import 'package:wp_commander/domain/entities/comment_entity.dart';

import 'remote/wp_api_datasource.dart';

abstract class CommentsRemoteDataSource {
  Future<List<CommentEntity>> getComments(String url, String apiKey,
      {int page = 1, int perPage = 10});
  Future<CommentEntity?> getComment(String url, String apiKey, int commentId);
  Future<void> deleteComment(String url, String apiKey, int commentId);
  Future<CommentEntity> updateComment(
      String url, String apiKey, CommentEntity comment);
  Future<void> approveComment(String url, String apiKey, int commentId);
  Future<List<CommentEntity>> getPendingComments(String url, String apiKey);
  Future<int> getPendingCommentsCount(String url, String apiKey);
  Future<void> spamComment(String url, String apiKey, int commentId);
}

class CommentsRemoteDataSourceImpl implements CommentsRemoteDataSource {
  @override
  Future<void> approveComment(String url, String apiKey, int commentId) async {
    _getApi(url, apiKey).approveComment(commentId);
  }

  @override
  Future<void> deleteComment(String url, String apiKey, int commentId) async {
    _getApi(url, apiKey).deleteComment(commentId);
  }

  @override
  Future<CommentEntity?> getComment(
      String url, String apiKey, int commentId) async {
    return await _getApi(url, apiKey).getComment(commentId);
  }

  @override
  Future<List<CommentEntity>> getComments(String url, String apiKey,
      {int page = 1, int perPage = 10}) async {
    return await _getApi(url, apiKey)
        .getComments(page: page, perPage: perPage);
  }

  @override
  Future<List<CommentEntity>> getPendingComments(String url, String apiKey) async {
    return await _getApi(url, apiKey).getPendingComments();
  }

  @override
  Future<int> getPendingCommentsCount(String url, String apiKey) async {
    return await _getApi(url, apiKey).getPendingCommentsCount();
  }

  @override
  Future<void> spamComment(String url, String apiKey, int commentId) async {
    await _getApi(url, apiKey).spamComment(commentId);
  }

  @override
  Future<CommentEntity> updateComment(
      String url, String apiKey, CommentEntity comment) async {
    return await _getApi(url, apiKey).updateComment(comment);
  }

  WPApiDataSource _getApi(String url, String apiKey) {
    return WPApiDataSource(baseUrl: url, apiKey: apiKey);
  }
}
