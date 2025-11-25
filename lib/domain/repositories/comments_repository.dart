import 'package:either_dart/either.dart';

import '../../core/errors/failures.dart';
import '../entities/comment_entity.dart';

abstract class CommentsRepository {
  Future<Either<Failure, List<CommentEntity>>> getComments(String siteId, {int page = 1, int perPage = 10});

  Future<Either<Failure, CommentEntity>> getComment(String siteId, int commentId);

  Future<Either<Failure, List<CommentEntity>>> getPendingComments(String siteId);

  Future<Either<Failure, bool>> approveComment(String siteId, int commentId);

  Future<Either<Failure, bool>> deleteComment(String siteId, int commentId);

  Future<Either<Failure, bool>> spamComment(String siteId, int commentId);

  Future<Either<Failure, int>> getPendingCommentsCount(String siteId);

  Future<Either<Failure, CommentEntity>> updateComment(String siteId, CommentEntity comment);
}
