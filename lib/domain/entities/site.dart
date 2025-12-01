import 'dart:convert';

class Site {
  final String name;
  final String url;
  final String username;
  final String password;

  Site({
    required this.name,
    required this.url,
    required this.username,
    required this.password,
  });

  /// Crée une instance de Site à partir d'une map JSON.
  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      name: json['name'] as String,
      url: json['url'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
    );
  }

  /// Convertit une instance de Site en une map JSON.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'username': username,
      'password': password,
    };
  }
}
