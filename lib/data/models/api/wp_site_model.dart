class WPSiteModel {
  final String name;
  final String description;
  final String url;
  final String? icon;
  final String? adminEmail;
  final String timezone;
  final String language;

  WPSiteModel({
    required this.name,
    required this.description,
    required this.url,
    this.icon,
    this.adminEmail,
    required this.timezone,
    required this.language,
  });

  // From JSON
  factory WPSiteModel.fromJson(Map<String, dynamic> json) {
    return WPSiteModel(
      name: json['name'] ?? 'Unknown Site',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      icon: json['site_icon'],
      adminEmail: json['admin_email'],
      timezone: json['timezone'] ?? 'UTC',
      language: json['language'] ?? 'en',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'url': url,
      'site_icon': icon,
      'admin_email': adminEmail,
      'timezone': timezone,
      'language': language,
    };
  }
}