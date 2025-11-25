import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/comments/approve_comment.dart';
import '../../../domain/usecases/comments/delete_comment.dart';
import '../../../domain/usecases/comments/get_comments.dart';
import '../../../domain/usecases/site/add_site_usecase.dart';
import '../../../domain/usecases/site/validate_site_usecase.dart';
import '../../../domain/usecases/stats/get_stats_usecase.dart';
import '../../../domain/usecases/health/check_site_health_usecase.dart';
import './repository_providers.dart';

// Use Cases pour les Sites
final addSiteUseCaseProvider = Provider<AddSiteUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return AddSiteUseCase(repository);
});

final validateSiteUseCaseProvider = Provider<ValidateSiteUseCase>((ref) {
  final repository = ref.watch(siteRepositoryProvider);
  return ValidateSiteUseCase(repository);
});

// Use Cases pour les Statistiques
final getStatsUseCaseProvider = Provider<GetStatsUseCase>((ref) {
  final repository = ref.watch(statsRepositoryProvider);
  return GetStatsUseCase(repository);
});

// Use Cases pour la Santé
final checkSiteHealthUseCaseProvider = Provider<CheckSiteHealthUseCase>((ref) {
  final repository = ref.watch(healthRepositoryProvider);
  return CheckSiteHealthUseCase(repository);
});

// Use Cases pour les Commentaires
final getAllCommentsUseCaseProvider = Provider<GetCommentsUseCase>((ref) {
  final repository = ref.watch(commentsRepositoryProvider);
  return GetCommentsUseCase(repository);
});

final approveCommentUseCaseProvider = Provider<ApproveCommentUseCase>((ref) {
  final repository = ref.watch(commentsRepositoryProvider);
  return ApproveCommentUseCase(repository);
});

final deleteCommentUseCaseProvider = Provider<DeleteCommentUseCase>((ref) {
  final repository = ref.watch(commentsRepositoryProvider);
  return DeleteCommentUseCase(repository);
});
