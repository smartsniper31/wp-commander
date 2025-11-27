import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/comment_entity.dart';
import '../../../domain/usecases/comments/approve_comment_usecase.dart';
import '../../../domain/usecases/comments/delete_comment_usecase.dart';
import '../../../domain/usecases/comments/fetch_comments_usecase.dart';
import '../../../domain/usecases/comments/spam_comment_usecase.dart';

part 'comments_notifier.g.dart';

@Riverpod(keepAlive: true)
class CommentsNotifier extends _$CommentsNotifier {
  @override
  Future<List<CommentEntity>> build(String siteId) async {
    final params = FetchCommentsParams(siteId: siteId);
    final result = await ref.watch(fetchCommentsUseCaseProvider).execute(params);
    return result.fold(
      (failure) => throw failure,
      (comments) => comments,
    );
  }

  Future<void> approveComment(String siteId, int commentId) async {
    final approveCommentUseCase = ref.read(approveCommentUseCaseProvider);
    await approveCommentUseCase.execute(siteId, commentId);
    ref.invalidateSelf();
  }

  Future<void> deleteComment(String siteId, int commentId) async {
    final deleteCommentUseCase = ref.read(deleteCommentUseCaseProvider);
    await deleteCommentUseCase.execute(siteId, commentId);
    ref.invalidateSelf();
  }

  Future<void> spamComment(String siteId, int commentId) async {
    final spamCommentUseCase = ref.read(spamCommentUseCaseProvider);
    await spamCommentUseCase.execute(siteId, commentId);
    ref.invalidateSelf();
  }
}
