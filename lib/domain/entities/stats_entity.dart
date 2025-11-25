import 'package:equatable/equatable.dart';

class StatsEntity extends Equatable {
  final int posts;
  final int pages;
  final int comments;
  final int approvedComments;
  final int pending;
  final int users;
  final DateTime lastUpdated;

  const StatsEntity({
    required this.posts,
    required this.pages,
    required this.comments,
    required this.approvedComments,
    required this.pending,
    required this.users,
    required this.lastUpdated,
  });

  static StatsEntity empty() {
    return StatsEntity(
      posts: 0,
      pages: 0,
      comments: 0,
      approvedComments: 0,
      pending: 0,
      users: 0,
      lastUpdated: DateTime.fromMicrosecondsSinceEpoch(0),
    );
  }

  @override
  List<Object?> get props => [
        posts,
        pages,
        comments,
        approvedComments,
        pending,
        users,
        lastUpdated,
      ];
}
