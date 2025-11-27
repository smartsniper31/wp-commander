import 'package:either_dart/either.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/domain/repositories/comments_repository.dart';

class DeleteCommentUseCase {
  final CommentsRepository repository;

  DeleteCommentUseCase(this.repository);

  Future<Either<Failure, void>> execute(String siteId, int commentId) async {
    return repository.deleteComment(siteId, commentId);
  }
}
