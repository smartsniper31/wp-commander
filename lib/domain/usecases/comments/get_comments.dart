import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/failures.dart';

import '../../../core/providers/repository_providers.dart';
import '../../entities/comment_entity.dart';
import '../../repositories/comments_repository.dart';

class GetCommentsUseCase {
  final CommentsRepository _repository;

  GetCommentsUseCase(this._repository);

  Future<Either<Failure, List<CommentEntity>>> call(String siteId, {String status = 'all'}) async {
    // The repository method does not have a status parameter.
    // I will call it without for now.
    return await _repository.getComments(siteId);
  }
}

final getCommentsUseCaseProvider = Provider<GetCommentsUseCase>((ref) {
  final repository = ref.watch(commentsRepositoryProvider);
  return GetCommentsUseCase(repository);
});
