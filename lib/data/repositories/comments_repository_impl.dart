import 'package:either_dart/either.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/data/datasources/comments_remote_datasource.dart';
import 'package:wp_commander/data/datasources/local/site_local_datasource.dart';
import 'package:wp_commander/domain/entities/comment_entity.dart';
import 'package:wp_commander/domain/repositories/comments_repository.dart';

class CommentsRepositoryImpl implements CommentsRepository {
  final CommentsRemoteDataSource remoteDataSource;
  final SiteLocalDataSource siteLocalDataSource;

  CommentsRepositoryImpl(
      {required this.remoteDataSource, required this.siteLocalDataSource});

  @override
  Future<Either<Failure, void>> approveComment(
      String siteId, int commentId) async {
    try {
      final site = await siteLocalDataSource.getSiteById(siteId);
      if (site == null) {
        return Left(CacheFailure(message: 'Site not found'));
      }
      await remoteDataSource.approveComment(site.url, site.apiKey, commentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to approve comment'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(
      String siteId, int commentId) async {
    try {
      final site = await siteLocalDataSource.getSiteById(siteId);
      if (site == null) {
        return Left(CacheFailure(message: 'Site not found'));
      }
      await remoteDataSource.deleteComment(site.url, site.apiKey, commentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete comment'));
    }
  }

  @override
  Future<Either<Failure, CommentEntity?>> getComment(
      String siteId, int commentId) async {
    try {
      final site = await siteLocalDataSource.getSiteById(siteId);
      if (site == null) {
        return Left(CacheFailure(message: 'Site not found'));
      }
      final comment = await remoteDataSource.getComment(
          site.url, site.apiKey, commentId);
      return Right(comment);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get comment'));
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getComments(String siteId,
      {int page = 1, int perPage = 10}) async {
    try {
      final site = await siteLocalDataSource.getSiteById(siteId);
      if (site == null) {
        return Left(CacheFailure(message: 'Site not found'));
      }
      final comments = await remoteDataSource.getComments(site.url, site.apiKey,
          page: page, perPage: perPage);
      return Right(comments);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get comments'));
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getPendingComments(
      String siteId) async {
    try {
      final site = await siteLocalDataSource.getSiteById(siteId);
      if (site == null) {
        return Left(CacheFailure(message: 'Site not found'));
      }
      final comments =
          await remoteDataSource.getPendingComments(site.url, site.apiKey);
      return Right(comments);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get pending comments'));
    }
  }

  @override
  Future<Either<Failure, int>> getPendingCommentsCount(String siteId) async {
    try {
      final site = await siteLocalDataSource.getSiteById(siteId);
      if (site == null) {
        return Left(CacheFailure(message: 'Site not found'));
      }
      final count = await remoteDataSource.getPendingCommentsCount(
          site.url, site.apiKey);
      return Right(count);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Failed to get pending comments count'));
    }
  }

  @override
  Future<Either<Failure, void>> spamComment(String siteId, int commentId) async {
    try {
      final site = await siteLocalDataSource.getSiteById(siteId);
      if (site == null) {
        return Left(CacheFailure(message: 'Site not found'));
      }
      await remoteDataSource.spamComment(site.url, site.apiKey, commentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to spam comment'));
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> updateComment(
      String siteId, CommentEntity comment) async {
    try {
      final site = await siteLocalDataSource.getSiteById(siteId);
      if (site == null) {
        return Left(CacheFailure(message: 'Site not found'));
      }
      final updatedComment = await remoteDataSource.updateComment(
          site.url, site.apiKey, comment);
      return Right(updatedComment);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update comment'));
    }
  }
}
