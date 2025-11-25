import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failures.dart';
import '../../../core/providers/repository_providers.dart';
import '../../repositories/comments_repository.dart';

class SpamCommentUseCase {
  final CommentsRepository _repository;

  SpamCommentUseCase(this._repository);

  Future<Either<Failure, bool>> call(String siteId, int commentId) async {
    return await _repository.spamComment(siteId, commentId);
  }
}

final spamCommentUseCaseProvider = Provider<SpamCommentUseCase>((ref) {
  final repository = ref.watch(commentsRepositoryProvider);
  return SpamCommentUseCase(repository);
});
