import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/errors/exceptions.dart';
import '../models/site_model.dart';

abstract class SiteRemoteDataSource {
  Future<SiteModel> getSite(String url);
  Future<SiteModel> addSite(String url, String apiKey);
  Future<bool> validateConnection(String url, String apiKey);
}

class SiteRemoteDataSourceImpl implements SiteRemoteDataSource {
  final http.Client client;

  SiteRemoteDataSourceImpl({required this.client});

  @override
  Future<SiteModel> getSite(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return SiteModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SiteModel> addSite(String url, String apiKey) async {
    final response = await client.post(
      Uri.parse('$url/wp-json/wp-commander/v1/sites'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({'url': url}),
    );

    if (response.statusCode == 201) {
      return SiteModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> validateConnection(String url, String apiKey) async {
    try {
      final response = await client.get(
        Uri.parse('$url/wp-json/wp-commander/v1/connection/validate'),
        headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
