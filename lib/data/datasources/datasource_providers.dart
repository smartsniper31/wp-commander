import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'site_remote_datasource.dart';
import 'stats_remote_datasource.dart';
import 'health_remote_datasource.dart';
import 'comments_remote_datasource.dart';
import 'local/site_local_datasource.dart';
import 'local/site_local_datasource_impl.dart';

// Fournisseur pour le client HTTP
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// Fournisseur pour SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError('SharedPreferences not initialized'));

// Fournisseurs pour les sources de données distantes
final siteRemoteDataSourceProvider = Provider<SiteRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  return SiteRemoteDataSourceImpl(client: client);
});

final statsRemoteDataSourceProvider = Provider<StatsRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  return StatsRemoteDataSourceImpl(client: client);
});

final healthRemoteDataSourceProvider = Provider<HealthRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  return HealthRemoteDataSourceImpl(client: client);
});

final commentsRemoteDataSourceProvider = Provider<CommentsRemoteDataSource>((ref) {
  return CommentsRemoteDataSourceImpl();
});

// Fournisseur pour la source de données locale de sites
final siteLocalDataSourceProvider = Provider<SiteLocalDataSource>((ref) {
  return SiteLocalDataSourceImpl();
});
