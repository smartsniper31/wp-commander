import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wp_commander/core/providers/repository_providers.dart';
import 'package:wp_commander/domain/entities/health_entity.dart';
import 'package:wp_commander/domain/usecases/health/check_site_health_usecase.dart';

final siteHealthProvider = FutureProvider.autoDispose.family<HealthEntity, String>((ref, siteId) async {
  final healthRepository = ref.watch(healthRepositoryProvider);
  final checkHealthUseCase = CheckSiteHealthUseCase(healthRepository);
  final result = await checkHealthUseCase.execute(siteId);

  if (result.isSuccess) {
    return result.data!;
  } else {
    throw result.error!;
  }
});
