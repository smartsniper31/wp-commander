import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/comment_entity.dart';
import '../../../domain/usecases/comments/approve_comment.dart';
import '../../../domain/usecases/comments/delete_comment.dart';
import '../../../domain/usecases/comments/get_comments.dart';
import '../../../domain/usecases/comments/spam_comment.dart';

part 'comments_notifier.g.dart';

@Riverpod(keepAlive: true)
class CommentsNotifier extends _$CommentsNotifier {
  @override
  Future<List<CommentEntity>> build(String siteId) {
    return ref.watch(getCommentsUseCaseProvider).call(siteId);
  }

  Future<void> approveComment(String siteId, int commentId) async {
    final approveCommentUseCase = ref.read(approveCommentUseCaseProvider);
    await approveCommentUseCase.call(siteId, commentId);
    ref.invalidateSelf();
  }

  Future<void> deleteComment(String siteId, int commentId) async {
    final deleteCommentUseCase = ref.read(deleteCommentUseCaseProvider);
    await deleteCommentUseCase.call(siteId, commentId);
    ref.invalidateSelf();
  }

  Future<void> spamComment(String siteId, int commentId) async {
    final spamCommentUseCase = ref.read(spamCommentUseCaseProvider);
    await spamCommentUseCase.call(siteId, commentId);
    ref.invalidateSelf();
  }
}
