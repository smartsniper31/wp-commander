import '../../../domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.authorName,
    required super.authorEmail,
    required super.authorAvatar,
    required super.content,
    required super.date,
    required super.status,
    required super.postTitle,
    required super.postId,
    required super.authorIp,
    required super.authorUrl,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      authorName: json['author_name'] ?? '',
      authorEmail: json['author_email'] ?? '',
      authorAvatar: json['author_avatar_urls']?['96'] ?? '',
      content: json['content']?['rendered'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'unknown',
      postTitle: json['post_title'] ?? '', // Ce champ peut ne pas être dans le JSON
      postId: json['post'] ?? 0,
      authorIp: json['author_ip'] ?? '',
      authorUrl: json['author_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_name': authorName,
      'author_email': authorEmail,
      'content': {'rendered': content},
      'date': date.toIso8601String(),
      'status': status,
      'post': postId,
    };
  }
}
