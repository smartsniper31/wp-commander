import '../entities/comment_entity.dart';

abstract class CommentsRepository {
  Future<List<CommentEntity>> getComments(String siteId, {int page = 1, int perPage = 10});

  Future<CommentEntity?> getComment(String siteId, int commentId);

  Future<List<CommentEntity>> getPendingComments(String siteId);

  Future<void> approveComment(String siteId, int commentId);

  Future<void> deleteComment(String siteId, int commentId);

  Future<void> spamComment(String siteId, int commentId);

  Future<int> getPendingCommentsCount(String siteId);

  Future<CommentEntity> updateComment(String siteId, CommentEntity comment);
}
