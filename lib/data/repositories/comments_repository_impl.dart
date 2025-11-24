import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/comments_repository.dart';
import '../../domain/entities/comment_entity.dart';
import '../datasources/remote/wp_api_datasource.dart';
import '../models/api/wp_comment_model.dart';
import '../../presentation/notifiers/sites_notifier.dart';

class CommentsRepositoryImpl implements CommentsRepository {
  final Ref ref;

  CommentsRepositoryImpl(this.ref);

  Future<WPApiDataSource> _getDataSource(String siteId) async {
    final site = await ref.read(sitesNotifierProvider.notifier).getSiteById(siteId);
    return WPApiDataSource(
      baseUrl: site!.url,
      apiKey: site.apiKey,
    );
  }

  @override
  Future<List<CommentEntity>> getComments(String siteId, {String status = 'all'}) async {
    final dataSource = await _getDataSource(siteId);
    final commentsData = await dataSource.getComments(status: status);
    return commentsData.map((data) => WPCommentModel.fromJson(data).toEntity()).toList();
  }

  @override
  Future<List<CommentEntity>> getPendingComments(String siteId) async {
    return getComments(siteId, status: 'hold');
  }

  @override
  Future<bool> approveComment(String siteId, int commentId) async {
    final dataSource = await _getDataSource(siteId);
    return dataSource.approveComment(commentId);
  }

  @override
  Future<bool> deleteComment(String siteId, int commentId) async {
    final dataSource = await _getDataSource(siteId);
    return dataSource.deleteComment(commentId);
  }

  @override
  Future<bool> spamComment(String siteId, int commentId) async {
    // final dataSource = await _getDataSource(siteId);
    // Not implemented in the datasource, so we return false
    return false;
  }

  @override
  Future<int> getPendingCommentsCount(String siteId) async {
    final pendingComments = await getPendingComments(siteId);
    return pendingComments.length;
  }
}
