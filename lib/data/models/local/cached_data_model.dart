import 'package:hive/hive.dart';

part 'cached_data_model.g.dart';

@HiveType(typeId: 0)
class CachedDataModel {
  @HiveField(0)
  final String key;
  
  @HiveField(1)
  final String data;
  
  @HiveField(2)
  final DateTime createdAt;
  
  @HiveField(3)
  final DateTime expiresAt;
  
  @HiveField(4)
  final String dataType; // 'stats', 'health', 'comments'
  
  @HiveField(5)
  final String siteId;

  CachedDataModel({
    required this.key,
    required this.data,
    required this.createdAt,
    required this.expiresAt,
    required this.dataType,
    required this.siteId,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  bool get isValid => !isExpired && data.isNotEmpty;
  
  Duration get timeUntilExpiry => expiresAt.difference(DateTime.now());
}
