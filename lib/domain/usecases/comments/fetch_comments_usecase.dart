import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/providers/repository_providers.dart';
import '../../entities/comment_entity.dart';
import '../../repositories/comments_repository.dart';

class FetchCommentsUseCase {
  final CommentsRepository _repository;

  FetchCommentsUseCase(this._repository);

  Future<List<CommentEntity>> execute(FetchCommentsParams params) async {
    try {
      if (params.status == 'pending') {
        return await _repository.getPendingComments(params.siteId);
      }
      return await _repository.getComments(params.siteId, page: params.page, perPage: params.perPage);
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: e.toString());
    }
  }
}

final fetchCommentsUseCaseProvider = Provider<FetchCommentsUseCase>((ref) {
  return FetchCommentsUseCase(ref.read(commentsRepositoryProvider));
});

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
