import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/errors/exceptions.dart';
import '../models/site_model.dart';

abstract class SiteRemoteDataSource {
  Future<SiteModel> getSite(String url);
  Future<SiteModel> addSite(String url, String apiKey);
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
    // TODO: implement addSite
    throw UnimplementedError();
  }
}
