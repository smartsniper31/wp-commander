import 'package:equatable/equatable.dart';

class WPStatsModel extends Equatable {
  final int posts;
  final int pages;
  final int comments;
  final int approvedComments;

  const WPStatsModel({
    required this.posts,
    required this.pages,
    required this.comments,
    required this.approvedComments,
  });

  factory WPStatsModel.fromJson(Map<String, dynamic> json) {
    return WPStatsModel(
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

  @override
  List<Object?> get props => [posts, pages, comments, approvedComments];
}
