import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_providers.dart';
import '../../entities/comment_entity.dart';
import '../../repositories/comments_repository.dart';

class GetCommentsUseCase {
  final CommentsRepository _repository;

  GetCommentsUseCase(this._repository);

  Future<List<CommentEntity>> call(String siteId, {String status = 'all'}) async {
    return await _repository.getComments(siteId, status: status);
  }
}

final getCommentsUseCaseProvider = Provider<GetCommentsUseCase>((ref) {
  final repository = ref.watch(commentsRepositoryProvider);
  return GetCommentsUseCase(repository);
});
