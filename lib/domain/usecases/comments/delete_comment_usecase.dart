import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/providers/repository_providers.dart';
import '../../repositories/comments_repository.dart';

class DeleteCommentUseCase {
  final CommentsRepository _repository;

  DeleteCommentUseCase(this._repository);

  Future<void> execute(String siteId, int commentId) async {
    try {
      await _repository.deleteComment(siteId, commentId);
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: e.toString());
    }
  }
}

final deleteCommentUseCaseProvider = Provider<DeleteCommentUseCase>((ref) {
  return DeleteCommentUseCase(ref.read(commentsRepositoryProvider));
});
