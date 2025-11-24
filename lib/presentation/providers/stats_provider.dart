import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/stats_repository_impl.dart';
import '../../domain/repositories/stats_repository.dart';

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepositoryImpl(ref);
});
