class CommentModel {
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

  const CommentModel({
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
}
