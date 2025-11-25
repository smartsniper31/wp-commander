import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/data/repositories/site_repository_impl.dart';

import '../../core/errors/exceptions.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/comments_repository.dart';
import '../datasources/remote/wp_api_datasource.dart';
import '../../core/providers/repository_providers.dart';

class CommentsRepositoryImpl implements CommentsRepository {
  final Ref ref;

  CommentsRepositoryImpl(this.ref);

  Future<WPApiDataSource> _getDataSource(String siteId) async {
    final siteRepository = ref.read(siteRepositoryProvider);
    final site = await siteRepository.getSiteById(siteId);
    if (site != null) {
      return WPApiDataSource(
        baseUrl: site.url,
        apiKey: site.apiKey,
      );
    } else {
      throw UseCaseException(message: 'Site not found with ID: $siteId', code: 'SITE_NOT_FOUND');
    }
  }

  @override
  Future<List<CommentEntity>> getComments(String siteId, {int page = 1, int perPage = 10}) async {
    try {
      final dataSource = await _getDataSource(siteId);
      return await dataSource.getComments(page: page, perPage: perPage);
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: 'Failed to fetch comments: ${e.toString()}');
    }
  }

  @override
  Future<CommentEntity?> getComment(String siteId, int commentId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      return await dataSource.getComment(commentId);
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: 'Failed to fetch comment $commentId: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteComment(String siteId, int commentId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      await dataSource.deleteComment(commentId);
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: 'Failed to delete comment $commentId: ${e.toString()}');
    }
  }

  @override
  Future<CommentEntity> updateComment(String siteId, CommentEntity comment) async {
    try {
      final dataSource = await _getDataSource(siteId);
      return await dataSource.updateComment(comment);
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: 'Failed to update comment ${comment.id}: ${e.toString()}');
    }
  }

  @override
  Future<void> approveComment(String siteId, int commentId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      await dataSource.approveComment(commentId);
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: 'Failed to approve comment $commentId: ${e.toString()}');
    }
  }

  @override
  Future<List<CommentEntity>> getPendingComments(String siteId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      return await dataSource.getPendingComments();
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: 'Failed to get pending comments: ${e.toString()}');
    }
  }

  @override
  Future<int> getPendingCommentsCount(String siteId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      return await dataSource.getPendingCommentsCount();
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: 'Failed to get pending comments count: ${e.toString()}');
    }
  }

  @override
  Future<void> spamComment(String siteId, int commentId) async {
    try {
      final dataSource = await _getDataSource(siteId);
      await dataSource.spamComment(commentId);
    } on UseCaseException {
      rethrow;
    } catch (e) {
      throw UseCaseException(message: 'Failed to spam comment $commentId: ${e.toString()}');
    }
  }
}
