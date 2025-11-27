import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wp_commander/domain/usecases/sites/add_site_usecase.dart';
import 'package:wp_commander/domain/usecases/sites/delete_site_usecase.dart';
import 'package:wp_commander/domain/usecases/sites/get_sites_usecase.dart';
import 'package:wp_commander/presentation/notifiers/sites_notifier.dart';
import 'package:wp_commander/presentation/notifiers/sites_state.dart';

// Mocks for UseCases
class MockGetSitesUseCase extends Mock implements GetSitesUseCase {}
class MockAddSiteUseCase extends Mock implements AddSiteUseCase {}
class MockDeleteSiteUseCase extends Mock implements DeleteSiteUseCase {}

class MockSitesNotifier extends SitesNotifier {
  MockSitesNotifier()
      : super(
          getSitesUseCase: MockGetSitesUseCase(),
          addSiteUseCase: MockAddSiteUseCase(),
          deleteSiteUseCase: MockDeleteSiteUseCase(),
        );

  @override
  Future<void> fetchSites() async {
    // Do nothing in mock
  }
}
