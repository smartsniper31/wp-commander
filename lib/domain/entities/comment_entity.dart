import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final int id;
  final String authorName;
  final String authorEmail;
  final String authorAvatar;
  final String content;
  final DateTime date;
  final String status;
  final String postTitle;
  final int postId;
  final String authorIp;
  final String authorUrl;

  const CommentEntity({
    required this.id,
    required this.authorName,
    required this.authorEmail,
    required this.authorAvatar,
    required this.content,
    required this.date,
    required this.status,
    required this.postTitle,
    required this.postId,
    required this.authorIp,
    required this.authorUrl,
  });

  @override
  List<Object?> get props => [
        id,
        authorName,
        authorEmail,
        authorAvatar,
        content,
        date,
        status,
        postTitle,
        postId,
        authorIp,
        authorUrl,
      ];
}
