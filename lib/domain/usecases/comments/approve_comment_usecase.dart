
import '../../repositories/comments_repository.dart';
import '../base_usecase.dart';

class ApproveCommentUseCase extends UseCase<void, ApproveCommentParams> {
  final CommentsRepository repository;

  ApproveCommentUseCase(this.repository);

  @override
  Future<UseCaseResult<void>> execute(ApproveCommentParams params) async {
    // TODO: Implémenter
    throw UnimplementedError();
  }
}

class ApproveCommentParams {
  final String siteId;
  final String commentId;

  const ApproveCommentParams({
    required this.siteId,
    required this.commentId,
  });
}
