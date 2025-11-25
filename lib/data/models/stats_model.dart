import 'package:flutter/foundation.dart';

import '../../../domain/entities/stats_entity.dart';

@immutable
class StatsModel extends StatsEntity {
  const StatsModel({
    required super.posts,
    required super.pages,
    required super.comments,
    required super.approvedComments,
    required super.pending,
    required super.users,
    required super.lastUpdated,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      posts: json['posts'] ?? 0,
      pages: json['pages'] ?? 0,
      comments: json['comments'] ?? 0,
      approvedComments: json['approved_comments'] ?? 0,
      pending: json['pending'] ?? 0,
      users: json['users'] ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts,
      'pages': pages,
      'comments': comments,
      'approved_comments': approvedComments,
      'pending': pending,
      'users': users,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
