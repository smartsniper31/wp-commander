import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/failures.dart';
import '../../core/providers/repository_providers.dart';
import '../../domain/repositories/comments_repository.dart';
import '../../domain/entities/comment_entity.dart';
import '../datasources/remote/wp_api_datasource.dart';

class CommentsRepositoryImpl implements CommentsRepository {
  final Ref ref;

  CommentsRepositoryImpl(this.ref);

  Future<WPApiDataSource> _getDataSource(String siteId) async {
    final siteEither = await ref.read(siteRepositoryProvider).getSiteById(siteId);
    if (siteEither.isRight) {
      final site = siteEither.right;
      return WPApiDataSource(
        baseUrl: site.url,
        apiKey: site.apiKey,
      );
    } else {
      throw Exception('Site not found'); // Ou une gestion d'erreur plus spécifique
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getComments(String siteId, {int page = 1, int perPage = 10}) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final comments = await dataSource.getComments(page: page, perPage: perPage);
      return Right(comments);
    } catch (e) {
      return Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> getComment(String siteId, int commentId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final comment = await dataSource.getComment(commentId);
      return Right(comment);
    } catch (e) {
      return Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteComment(String siteId, int commentId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final result = await dataSource.deleteComment(commentId);
      return Right(result);
    } catch (e) {
      return Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> updateComment(String siteId, CommentEntity comment) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final updatedComment = await dataSource.updateComment(comment);
      return Right(updatedComment);
    } catch (e) {
      return Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, bool>> approveComment(String siteId, int commentId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final result = await dataSource.approveComment(commentId);
      return Right(result);
    } catch (e) {
      return Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getPendingComments(String siteId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final comments = await dataSource.getPendingComments();
      return Right(comments);
    } catch (e) {
      return Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, int>> getPendingCommentsCount(String siteId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final count = await dataSource.getPendingCommentsCount();
      return Right(count);
    } catch (e) {
      return Left(Failure.server());
    }
  }

  @override
  Future<Either<Failure, bool>> spamComment(String siteId, int commentId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      final result = await dataSource.spamComment(commentId);
      return Right(result);
    } catch (e) {
      return Left(Failure.server());
    }
  }
}
