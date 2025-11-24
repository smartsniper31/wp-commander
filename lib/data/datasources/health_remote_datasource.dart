import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/errors/exceptions.dart';
import '../models/api/wp_health_model.dart';

abstract class HealthRemoteDataSource {
  Future<WPHealthModel> getHealth(String url);
}

class HealthRemoteDataSourceImpl implements HealthRemoteDataSource {
  final http.Client client;

  HealthRemoteDataSourceImpl({required this.client});

  @override
  Future<WPHealthModel> getHealth(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WPHealthModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
