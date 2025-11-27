import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/domain/entities/comment_entity.dart';
import 'package:wp_commander/domain/usecases/comments/approve_comment.dart';
import 'package:wp_commander/domain/usecases/comments/delete_comment.dart';
import 'package:wp_commander/domain/usecases/comments/get_all_comments_usecase.dart';
import 'package:wp_commander/core/providers/usecase_providers.dart';

// État pour la liste des commentaires
class CommentsListState {
  final List<CommentEntity> comments;
  final bool isLoading;
  final String? error;
  final String filterStatus; // 'all', 'pending', 'approved', 'spam'
  final bool hasMore;
  final int currentPage;

  const CommentsListState({
    this.comments = const [],
    this.isLoading = false,
    this.error,
    this.filterStatus = 'all',
    this.hasMore = true,
    this.currentPage = 1,
  });

  CommentsListState copyWith({
    List<CommentEntity>? comments,
    bool? isLoading,
    String? error,
    String? filterStatus,
    bool? hasMore,
    int? currentPage,
  }) {
    return CommentsListState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filterStatus: filterStatus ?? this.filterStatus,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  bool get hasError => error != null;
  int get pendingCount {
    return comments.where((comment) => comment.status == 'hold').length;
  }

  List<CommentEntity> get filteredComments {
    if (filterStatus == 'all') return comments;
    return comments.where((comment) => comment.status == filterStatus).toList();
  }
}

// Notifier pour la liste des commentaires
class CommentsListNotifier extends StateNotifier<CommentsListState> {
  final String siteId;
  final GetAllCommentsUseCase _getAllCommentsUseCase;
  final ApproveCommentUseCase _approveCommentUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;

  CommentsListNotifier({
    required this.siteId,
    required GetAllCommentsUseCase getAllCommentsUseCase,
    required ApproveCommentUseCase approveCommentUseCase,
    required DeleteCommentUseCase deleteCommentUseCase,
  })  : _getAllCommentsUseCase = getAllCommentsUseCase,
        _approveCommentUseCase = approveCommentUseCase,
        _deleteCommentUseCase = deleteCommentUseCase,
        super(const CommentsListState());

  // Charger les commentaires
  Future<void> loadComments({bool loadMore = false}) async {
    if (state.isLoading) return;

    final nextPage = loadMore ? state.currentPage + 1 : 1;

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: nextPage,
    );

    try {
      final newComments = await _getAllCommentsUseCase.execute(
        siteId: siteId,
        page: nextPage,
        status: state.filterStatus,
      );
      
      state = state.copyWith(
        comments: loadMore ? [...state.comments, ...newComments] : newComments,
        isLoading: false,
        hasMore: newComments.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Changer le filtre
  void setFilter(String status) {
    state = state.copyWith(filterStatus: status);
    loadComments();
  }

  // Approuver un commentaire
  Future<void> approveComment(int commentId) async {
    final originalComments = state.comments;
    final updatedComments = state.comments.map((comment) {
      if (comment.id == commentId) {
        return comment.copyWith(status: 'approved');
      }
      return comment;
    }).toList();

    state = state.copyWith(comments: updatedComments);

    try {
      await _approveCommentUseCase.execute(siteId, commentId);
    } catch (e) {
      state = state.copyWith(
        comments: originalComments, // Revert on error
        error: e.toString(),
      );
    }
  }

  // Supprimer un commentaire
  Future<void> deleteComment(int commentId) async {
    final originalComments = state.comments;
    final updatedComments = originalComments.where((c) => c.id != commentId).toList();
    state = state.copyWith(comments: updatedComments);

    try {
      await _deleteCommentUseCase.execute(siteId, commentId);
    } catch (e) {
      state = state.copyWith(
        comments: originalComments, // Revert on error
        error: e.toString(),
      );
    }
  }

  // Actualiser les commentaires
  Future<void> refresh() async {
    await loadComments(loadMore: false);
  }

  // Effacer l'erreur
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider famille pour les commentaires par site
final commentsListProvider = StateNotifierProvider.family<
  CommentsListNotifier, CommentsListState, String>((ref, siteId) {
  return CommentsListNotifier(
    siteId: siteId,
    getAllCommentsUseCase: ref.watch(getAllCommentsUseCaseProvider),
    approveCommentUseCase: ref.watch(approveCommentUseCaseProvider),
    deleteCommentUseCase: ref.watch(deleteCommentUseCaseProvider),
  );
});
