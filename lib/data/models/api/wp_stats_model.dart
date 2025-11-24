import '../../../domain/entities/stats_entity.dart';

class WPStatsModel {
  final int totalPosts;
  final int totalPages;
  final int totalComments;
  final int approvedComments;
  final int pendingComments;
  final int spamComments;
  final int totalUsers;

  WPStatsModel({
    required this.totalPosts,
    required this.totalPages,
    required this.totalComments,
    required this.approvedComments,
    required this.pendingComments,
    required this.spamComments,
    required this.totalUsers,
  });

  factory WPStatsModel.fromJson(Map<String, dynamic> json) {
    return WPStatsModel(
      totalPosts: json['posts']?['total'] ?? 0,
      totalPages: json['pages']?['total'] ?? 0,
      totalComments: json['comments']?['total'] ?? 0,
      approvedComments: json['comments']?['approved'] ?? 0,
      pendingComments: json['comments']?['pending'] ?? 0,
      spamComments: json['comments']?['spam'] ?? 0,
      totalUsers: json['users']?['total'] ?? 0,
    );
  }

  StatsEntity toEntity() {
    return StatsEntity(
      posts: totalPosts,
      pages: totalPages,
      comments: totalComments,
      approvedComments: approvedComments,
      pendingComments: pendingComments,
      spamComments: spamComments,
      users: totalUsers,
    );
  }
}
