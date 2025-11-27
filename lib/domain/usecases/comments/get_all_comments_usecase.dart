import 'package:either_dart/either.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/domain/entities/comment_entity.dart';
import 'package:wp_commander/domain/repositories/comments_repository.dart';

class GetAllCommentsUseCase {
  final CommentsRepository repository;

  GetAllCommentsUseCase(this.repository);

  Future<Either<Failure, List<CommentEntity>>> execute({
    required String siteId,
    required int page,
    required String status,
  }) async {
    return repository.getComments(siteId, page: page, perPage: 10);
  }
}
