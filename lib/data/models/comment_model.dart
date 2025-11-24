import 'package:flutter/foundation.dart';

import '../../../domain/entities/comment_entity.dart';

@immutable
class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.authorName,
    required super.content,
    required super.date,
    required super.status,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      authorName: json['author_name'] ?? '',
      content: json['content']['rendered'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_name': authorName,
      'content': {'rendered': content},
      'date': date,
      'status': status,
    };
  }
}
