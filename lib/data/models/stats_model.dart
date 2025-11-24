import 'package:flutter/foundation.dart';

import '../../../domain/entities/stats_entity.dart';

@immutable
class StatsModel extends StatsEntity {
  const StatsModel({
    required super.posts,
    required super.pages,
    required super.comments,
    required super.approvedComments,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      posts: json['posts'] ?? 0,
      pages: json['pages'] ?? 0,
      comments: json['comments'] ?? 0,
      approvedComments: json['approved_comments'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts,
      'pages': pages,
      'comments': comments,
      'approved_comments': approvedComments,
    };
  }
}
