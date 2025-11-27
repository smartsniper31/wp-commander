import 'package:either_dart/either.dart';
import 'package:wp_commander/core/errors/failures.dart';
import '../../entities/comment_entity.dart';
import '../../repositories/comments_repository.dart';

class FetchCommentsUseCase {
  final CommentsRepository _repository;

  FetchCommentsUseCase(this._repository);

  Future<Either<Failure, List<CommentEntity>>> execute(FetchCommentsParams params) async {
    if (params.status == 'pending') {
      return _repository.getPendingComments(params.siteId);
    }
    return _repository.getComments(params.siteId, page: params.page, perPage: params.perPage);
  }
}

class FetchCommentsParams {
  final String siteId;
  final String status;
  final int page;
  final int perPage;

  const FetchCommentsParams({
    required this.siteId,
    this.status = 'all',
    this.page = 1,
    this.perPage = 10,
  });
}
