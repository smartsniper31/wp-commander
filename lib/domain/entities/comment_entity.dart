import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_entity.freezed.dart';
part 'comment_entity.g.dart';

@freezed
class CommentEntity with _$CommentEntity {
  const factory CommentEntity({
    required int id,
    required String authorName,
    required String authorEmail,
    required String authorAvatar,
    required String content,
    required DateTime date,
    required String status,
    required String postTitle,
    required int postId,
    required String authorIp,
    required String authorUrl,
  }) = _CommentEntity;

  factory CommentEntity.fromJson(Map<String, dynamic> json) =>
      _$CommentEntityFromJson(json);
}
