import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/errors/exceptions.dart';
import '../models/api/wp_comment_model.dart';

abstract class CommentsRemoteDataSource {
  Future<List<WPCommentModel>> getComments(String url);
}

class CommentsRemoteDataSourceImpl implements CommentsRemoteDataSource {
  final http.Client client;

  CommentsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<WPCommentModel>> getComments(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((i) => WPCommentModel.fromJson(i)).toList();
    } else {
      throw ServerException();
    }
  }
}
