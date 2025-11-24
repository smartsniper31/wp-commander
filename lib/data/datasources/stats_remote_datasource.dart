import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/errors/exceptions.dart';
import '../models/api/wp_stats_model.dart';

abstract class StatsRemoteDataSource {
  Future<WPStatsModel> getStats(String url);
}

class StatsRemoteDataSourceImpl implements StatsRemoteDataSource {
  final http.Client client;

  StatsRemoteDataSourceImpl({required this.client});

  @override
  Future<WPStatsModel> getStats(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WPStatsModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
