import 'package:flutter/foundation.dart';
import '../../../domain/entities/site_entity.dart';

@immutable
class SiteModel extends SiteEntity {
  const SiteModel({
    required super.id,
    required super.name,
    required super.url,
    required super.apiKey,
    required super.createdAt,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) {
    return SiteModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      apiKey: json['api_key'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  factory SiteModel.fromEntity(SiteEntity entity) {
    return SiteModel(
      id: entity.id,
      name: entity.name,
      url: entity.url,
      apiKey: entity.apiKey,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'api_key': apiKey,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  SiteEntity toEntity() {
    return SiteEntity(
      id: id,
      name: name,
      url: url,
      apiKey: apiKey,
      createdAt: createdAt,
    );
  }
}
