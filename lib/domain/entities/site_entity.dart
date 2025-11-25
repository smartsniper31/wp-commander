
class SiteEntity {
  final String id;
  final String name;
  final String url;
  final String apiKey;
  final DateTime createdAt;
  final DateTime? lastSync;
  final bool isConnected;
  final String? siteIcon;
  final String? adminEmail;

  const SiteEntity({
    required this.id,
    required this.name,
    required this.url,
    required this.apiKey,
    required this.createdAt,
    this.lastSync,
    this.isConnected = false,
    this.siteIcon,
    this.adminEmail,
  });

  String get cleanUrl => url.replaceAll(RegExp(r'^https?://'), '');

  SiteEntity copyWith({
    String? id,
    String? name,
    String? url,
    String? apiKey,
    DateTime? createdAt,
    DateTime? lastSync,
    bool? isConnected,
    String? siteIcon,
    String? adminEmail,
  }) {
    return SiteEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      apiKey: apiKey ?? this.apiKey,
      createdAt: createdAt ?? this.createdAt,
      lastSync: lastSync ?? this.lastSync,
      isConnected: isConnected ?? this.isConnected,
      siteIcon: siteIcon ?? this.siteIcon,
      adminEmail: adminEmail ?? this.adminEmail,
    );
  }
}
