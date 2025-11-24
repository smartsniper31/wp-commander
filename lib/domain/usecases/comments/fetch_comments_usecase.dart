import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/comments_repository.dart';
import '../../entities/comment_entity.dart';
import '../base_usecase.dart';

class FetchCommentsUseCase extends UseCase<List<CommentEntity>, FetchCommentsParams> {
  final CommentsRepository repository;

  FetchCommentsUseCase(this.repository);

  @override
  Future<UseCaseResult<List<CommentEntity>>> execute(FetchCommentsParams params) async {
    // TODO: Implémenter
    throw UnimplementedError();
  }
}

class FetchCommentsParams {
  final String siteId;
  final String status;

  const FetchCommentsParams({
    required this.siteId,
    this.status = 'all',
  });
}
