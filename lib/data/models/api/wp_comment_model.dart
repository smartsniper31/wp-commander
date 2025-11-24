import '../../../domain/entities/comment_entity.dart';

class WPCommentModel {
  final int id;
  final String authorName;
  final String authorEmail;
  final String authorAvatar;
  final String content;
  final String date;
  final String status;
  final String postTitle;
  final int postId;
  final String authorIp;
  final String authorUrl;

  WPCommentModel({
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

  factory WPCommentModel.fromJson(Map<String, dynamic> json) {
    return WPCommentModel(
      id: json['id'] as int? ?? 0,
      authorName: json['author_name'] as String? ?? 'Anonymous',
      authorEmail: json['author_email'] as String? ?? '',
      authorAvatar: json['author_avatar_urls']?['96'] as String? ?? '',
      content: json['content']?['rendered'] as String? ?? '',
      date: json['date'] as String? ?? DateTime.now().toIso8601String(),
      status: json['status'] as String? ?? 'unknown',
      postTitle: json['post_title'] as String? ?? 'Untitled Post',
      postId: json['post'] as int? ?? 0,
      authorIp: json['author_ip'] as String? ?? '',
      authorUrl: json['author_url'] as String? ?? '',
    );
  }

  CommentEntity toEntity() {
    return CommentEntity(
      id: id,
      authorName: authorName,
      authorEmail: authorEmail,
      authorAvatar: authorAvatar,
      content: content,
      date: DateTime.parse(date),
      status: status,
      postTitle: postTitle,
      postId: postId,
      authorIp: authorIp,
      authorUrl: authorUrl,
    );
  }
}
