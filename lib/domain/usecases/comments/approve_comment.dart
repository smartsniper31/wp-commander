import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_providers.dart';
import '../../repositories/comments_repository.dart';

class ApproveCommentUseCase {
  final CommentsRepository _repository;

  ApproveCommentUseCase(this._repository);

  Future<bool> call(String siteId, int commentId) async {
    return await _repository.approveComment(siteId, commentId);
  }
}

final approveCommentUseCaseProvider = Provider<ApproveCommentUseCase>((ref) {
  final repository = ref.watch(commentsRepositoryProvider);
  return ApproveCommentUseCase(repository);
});
