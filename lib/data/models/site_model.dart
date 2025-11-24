import 'package:flutter/foundation.dart';

import '../../../domain/entities/site_entity.dart';

@immutable
class SiteModel extends SiteEntity {
  const SiteModel({
    required super.id,
    required super.name,
    required super.url,
    required super.apiKey,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) {
    return SiteModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      apiKey: json['api_key'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'api_key': apiKey,
    };
  }
}
