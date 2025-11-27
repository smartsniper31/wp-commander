import 'package:either_dart/either.dart';

import 'package:wp_commander/core/errors/failures.dart';
import '../entities/site_entity.dart';

abstract class SiteRepository {
  Future<Either<Failure, List<SiteEntity>>> getSites();
  Future<Either<Failure, SiteEntity?>> getSiteById(String id);
  Future<Either<Failure, SiteEntity>> addSite(SiteEntity site);
  Future<Either<Failure, void>> deleteSite(String id);
  Future<Either<Failure, void>> updateSite(SiteEntity site);
  
  Future<Either<Failure, bool>> validateApiKey({
    required String url,
    required String apiKey,
  });
}