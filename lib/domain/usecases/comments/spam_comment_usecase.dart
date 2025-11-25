import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/providers/repository_providers.dart';
import '../../repositories/comments_repository.dart';

class SpamCommentUseCase {
  final CommentsRepository _repository;

  SpamCommentUseCase(this._repository);

  Future<void> execute(String siteId, int commentId) async {
    try {
      await _repository.spamComment(siteId, commentId);
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: e.toString());
    }
  }
}

final spamCommentUseCaseProvider = Provider<SpamCommentUseCase>((ref) {
  return SpamCommentUseCase(ref.read(commentsRepositoryProvider));
});
