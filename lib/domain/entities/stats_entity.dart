import 'package:equatable/equatable.dart';

class StatsEntity extends Equatable {
  final int posts;
  final int pages;
  final int comments;
  final int pending;
  final int users;
  final DateTime lastUpdated;

  const StatsEntity({
    required this.posts,
    required this.pages,
    required this.comments,
    required this.pending,
    required this.users,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        posts,
        pages,
        comments,
        pending,
        users,
        lastUpdated,
      ];
}
