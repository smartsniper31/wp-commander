import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/site_repository.dart';
import '../repositories/site_repository_impl.dart';
import '../datasources/datasource_providers.dart';

// Fournisseur pour le dépôt de sites
final siteRepositoryProvider = Provider<SiteRepository>((ref) {
  final remoteDataSource = ref.watch(siteRemoteDataSourceProvider);
  final localDataSource = ref.watch(siteLocalDataSourceProvider);
  return SiteRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});
