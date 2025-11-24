import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_providers.dart';
import '../../repositories/comments_repository.dart';

class DeleteCommentUseCase {
  final CommentsRepository _repository;

  DeleteCommentUseCase(this._repository);

  Future<bool> call(String siteId, int commentId) async {
    return await _repository.deleteComment(siteId, commentId);
  }
}

final deleteCommentUseCaseProvider = Provider<DeleteCommentUseCase>((ref) {
  final repository = ref.watch(commentsRepositoryProvider);
  return DeleteCommentUseCase(repository);
});
