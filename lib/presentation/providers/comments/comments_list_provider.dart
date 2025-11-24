import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/comment_entity.dart';

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
    return comments.where((comment) => comment.isPending).length;
  }
  
  List<CommentEntity> get filteredComments {
    if (filterStatus == 'all') return comments;
    return comments.where((comment) => comment.status == filterStatus).toList();
  }
}

// Notifier pour la liste des commentaires
class CommentsListNotifier extends StateNotifier<CommentsListState> {
  final String siteId;

  CommentsListNotifier({required this.siteId}) : super(const CommentsListState());

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
      // TODO: Implémenter le chargement depuis le repository
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newComments = <CommentEntity>[]; // Remplacer par les vraies données
      
      state = state.copyWith(
        comments: loadMore ? [...state.comments, ...newComments] : newComments,
        isLoading: false,
        hasMore: newComments.isNotEmpty, // Simuler la pagination
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement des commentaires',
      );
    }
  }

  // Changer le filtre
  void setFilter(String status) {
    state = state.copyWith(filterStatus: status);
  }

  // Approuver un commentaire
  Future<void> approveComment(int commentId) async {
    // TODO: Implémenter l'approbation via le repository
    final updatedComments = state.comments.map((comment) {
      if (comment.id == commentId) {
        return comment.copyWith(status: 'approved');
      }
      return comment;
    }).toList();

    state = state.copyWith(comments: updatedComments);
  }

  // Supprimer un commentaire
  Future<void> deleteComment(int commentId) async {
    final updatedComments = state.comments.where((c) => c.id != commentId).toList();
    state = state.copyWith(comments: updatedComments);
    
    // TODO: Implémenter la suppression dans le repository
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
  return CommentsListNotifier(siteId: siteId);
});
