import 'package:equatable/equatable.dart';

class StatsEntity extends Equatable {
  final int posts;
  final int pages;
  final int comments;
  final int approvedComments;
  final int pendingComments;
  final int spamComments;
  final int users;

  const StatsEntity({
    required this.posts,
    required this.pages,
    required this.comments,
    required this.approvedComments,
    required this.pendingComments,
    required this.spamComments,
    required this.users,
  });

  @override
  List<Object?> get props => [
        posts,
        pages,
        comments,
        approvedComments,
        pendingComments,
        spamComments,
        users,
      ];
}
