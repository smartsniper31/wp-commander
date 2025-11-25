import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failures.dart';
import '../../../core/providers/repository_providers.dart';
import '../../repositories/comments_repository.dart';

class ApproveCommentUseCase {
  final CommentsRepository _repository;

  ApproveCommentUseCase(this._repository);

  Future<Either<Failure, bool>> call(String siteId, int commentId) async {
    return await _repository.approveComment(siteId, commentId);
  }
}

final approveCommentUseCaseProvider = Provider<ApproveCommentUseCase>((ref) {
  final repository = ref.watch(commentsRepositoryProvider);
  return ApproveCommentUseCase(repository);
});
