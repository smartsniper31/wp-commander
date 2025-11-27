import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/core/providers/repository_providers.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/domain/repositories/site_repository.dart';
import 'package:wp_commander/presentation/notifiers/sites_notifier.dart';
import 'package:wp_commander/presentation/notifiers/sites_state.dart';

// 1. Listener class to mock the UI and listen to state changes
class Listener<T> {
  final List<T> states = [];
  void call(T? previous, T value) {
    states.add(value);
  }
}

// 2. Mock repository
class MockSiteRepository implements SiteRepository {
  final List<SiteEntity> _sites = [];

  @override
  Future<Either<Failure, SiteEntity>> addSite(SiteEntity site) async {
    if (site.name.isEmpty) {
      return Left(ServerFailure(message: 'Name cannot be empty'));
    }
    _sites.add(site);
    return Right(site);
  }

  @override
  Future<Either<Failure, void>> deleteSite(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SiteEntity?>> getSiteById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SiteEntity>>> getSites() async {
    return Right(_sites);
  }

  @override
  Future<Either<Failure, void>> updateSite(SiteEntity site) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> validateApiKey(
      {required String url, required String apiKey}) {
    throw UnimplementedError();
  }
}

void main() {
  group('SitesNotifier', () {
    late ProviderContainer container;
    late Listener<SitesState> listener;

    final tSite = SiteEntity(
      id: '1',
      name: 'Test Site',
      url: 'https://example.com',
      apiKey: 'test_key',
      createdAt: DateTime.now(),
    );

    setUp(() {
      container = ProviderContainer(
        overrides: [
          // 3. Override the repository provider with our mock
          siteRepositoryProvider.overrideWithValue(MockSiteRepository()),
        ],
      );
      listener = Listener<SitesState>();
      // 4. Listen to the notifier
      container.listen<SitesState>(
        sitesNotifierProvider,
        listener.call,
        fireImmediately: true,
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is correct', () {
      // Assert
      expect(
        container.read(sitesNotifierProvider),
        const SitesState.initial(),
      );
    });

    test('should get sites when initialized', () async {
      // Arrange
      // The notifier fetches sites on creation.
      // We need to wait for the event loop to process the future.
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(listener.states, [
        const SitesState.initial(),
        const SitesState.loading(),
        const SitesState.loaded([]),
      ]);
    });

    test('should add a site and update the state', () async {
      // Arrange
      final notifier = container.read(sitesNotifierProvider.notifier);

      // Act
      await notifier.addSite(tSite);

      // Assert
      expect(listener.states.last, SitesState.loaded([tSite]));
    });

    test('should return a failure when adding an invalid site', () async {
      // Arrange
      final notifier = container.read(sitesNotifierProvider.notifier);
      final tInvalidSite = tSite.copyWith(name: '');

      // Act
      await notifier.addSite(tInvalidSite);

      // Assert
      expect(
        listener.states.last,
        const SitesState.error('Name cannot be empty'),
      );
    });
  });
}
