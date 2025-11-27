import 'package:riverpod/riverpod.dart';
import 'package:wp_commander/domain/usecases/sites/add_site_usecase.dart';
import 'package:wp_commander/domain/usecases/sites/delete_site_usecase.dart';
import 'package:wp_commander/domain/usecases/sites/get_sites_usecase.dart';
import 'package:wp_commander/domain/usecases/sites/update_site_usecase.dart';
import 'package:wp_commander/domain/usecases/sites/validate_site_usecase.dart';
import 'package:wp_commander/domain/usecases/comments/approve_comment_usecase.dart';
import 'package:wp_commander/domain/usecases/comments/delete_comment_usecase.dart';
import 'package:wp_commander/domain/usecases/comments/fetch_comments_usecase.dart';
import 'package:wp_commander/domain/usecases/comments/spam_comment_usecase.dart';
import 'package:wp_commander/domain/usecases/stats/get_stats_usecase.dart';
import 'package:wp_commander/domain/usecases/stats/refresh_stats_usecase.dart';
import 'package:wp_commander/domain/usecases/health/check_site_health_usecase.dart';
import 'package:wp_commander/domain/usecases/health/monitor_health_usecase.dart';
import 'package:wp_commander/core/providers/repository_providers.dart';
import 'package:wp_commander/domain/usecases/stats/get_dashboard_stats_usecase.dart';
import 'package:wp_commander/domain/usecases/comments/get_all_comments_usecase.dart';

// Site Use Cases
final addSiteUseCaseProvider = Provider<AddSiteUseCase>((ref) {
  return AddSiteUseCase(ref.watch(siteRepositoryProvider));
});

final deleteSiteUseCaseProvider = Provider<DeleteSiteUseCase>((ref) {
  return DeleteSiteUseCase(ref.watch(siteRepositoryProvider));
});

final getSitesUseCaseProvider = Provider<GetSitesUseCase>((ref) {
  return GetSitesUseCase(ref.watch(siteRepositoryProvider));
});

final updateSiteUseCaseProvider = Provider<UpdateSiteUseCase>((ref) {
  return UpdateSiteUseCase(ref.watch(siteRepositoryProvider));
});

final validateSiteUseCaseProvider = Provider<ValidateSiteUseCase>((ref) {
  return ValidateSiteUseCase(ref.watch(siteRepositoryProvider));
});

// Comment Use Cases
final approveCommentUseCaseProvider = Provider<ApproveCommentUseCase>((ref) {
  final commentRepository = ref.watch(commentsRepositoryProvider);
  return ApproveCommentUseCase(commentRepository);
});

final deleteCommentUseCaseProvider = Provider<DeleteCommentUseCase>((ref) {
  final commentRepository = ref.watch(commentsRepositoryProvider);
  return DeleteCommentUseCase(commentRepository);
});

final fetchCommentsUseCaseProvider = Provider<FetchCommentsUseCase>((ref) {
  final commentRepository = ref.watch(commentsRepositoryProvider);
  return FetchCommentsUseCase(commentRepository);
});

final spamCommentUseCaseProvider = Provider<SpamCommentUseCase>((ref) {
  final commentRepository = ref.watch(commentsRepositoryProvider);
  return SpamCommentUseCase(commentRepository);
});

final getAllCommentsUseCaseProvider = Provider<GetAllCommentsUseCase>((ref) {
  final commentRepository = ref.watch(commentsRepositoryProvider);
  return GetAllCommentsUseCase(commentRepository);
});

// Stats Use Cases
final getStatsUseCaseProvider = Provider<GetStatsUseCase>((ref) {
  return GetStatsUseCase(ref.watch(statsRepositoryProvider));
});

final refreshStatsUseCaseProvider = Provider<RefreshStatsUseCase>((ref) {
  return RefreshStatsUseCase(ref.watch(statsRepositoryProvider));
});

final getDashboardStatsUseCaseProvider = Provider<GetDashboardStatsUseCase>((ref) {
  return GetDashboardStatsUseCase(ref.watch(statsRepositoryProvider));
});

// Health Use Cases
final checkSiteHealthUseCaseProvider = Provider<CheckSiteHealthUseCase>((ref) {
  return CheckSiteHealthUseCase(ref.watch(healthRepositoryProvider));
});

final monitorHealthUseCaseProvider = Provider<MonitorHealthUseCase>((ref) {
  return MonitorHealthUseCase(ref.watch(healthRepositoryProvider));
});
