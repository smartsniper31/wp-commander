// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentEntityImpl _$$CommentEntityImplFromJson(Map<String, dynamic> json) =>
    _$CommentEntityImpl(
      id: (json['id'] as num).toInt(),
      authorName: json['authorName'] as String,
      authorEmail: json['authorEmail'] as String,
      authorAvatar: json['authorAvatar'] as String,
      content: json['content'] as String,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      postTitle: json['postTitle'] as String,
      postId: (json['postId'] as num).toInt(),
      authorIp: json['authorIp'] as String,
      authorUrl: json['authorUrl'] as String,
    );

Map<String, dynamic> _$$CommentEntityImplToJson(_$CommentEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorName': instance.authorName,
      'authorEmail': instance.authorEmail,
      'authorAvatar': instance.authorAvatar,
      'content': instance.content,
      'date': instance.date.toIso8601String(),
      'status': instance.status,
      'postTitle': instance.postTitle,
      'postId': instance.postId,
      'authorIp': instance.authorIp,
      'authorUrl': instance.authorUrl,
    };
