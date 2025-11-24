import '../entities/comment_entity.dart';

abstract class CommentsRepository {
  Future<List<CommentEntity>> getComments(String siteId, {String status = 'all'});
  Future<List<CommentEntity>> getPendingComments(String siteId);
  Future<bool> approveComment(String siteId, int commentId);
  Future<bool> deleteComment(String siteId, int commentId);
  Future<bool> spamComment(String siteId, int commentId);
  Future<int> getPendingCommentsCount(String siteId);
}
