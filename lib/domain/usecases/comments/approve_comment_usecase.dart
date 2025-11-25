import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/providers/repository_providers.dart';
import '../../repositories/comments_repository.dart';

class ApproveCommentUseCase {
  final CommentsRepository _repository;

  ApproveCommentUseCase(this._repository);

  Future<void> execute(String siteId, int commentId) async {
    try {
      await _repository.approveComment(siteId, commentId);
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: e.toString());
    }
  }
}

final approveCommentUseCaseProvider = Provider<ApproveCommentUseCase>((ref) {
  return ApproveCommentUseCase(ref.read(commentsRepositoryProvider));
});
