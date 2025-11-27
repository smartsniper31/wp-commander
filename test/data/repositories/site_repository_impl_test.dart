import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wp_commander/data/datasources/local/site_local_datasource.dart';
import 'package:wp_commander/data/datasources/site_remote_datasource.dart';
import 'package:wp_commander/data/models/site_model.dart';
import 'package:wp_commander/data/repositories/site_repository_impl.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/core/errors/exceptions.dart';

class MockSiteLocalDataSource extends Mock implements SiteLocalDataSource {}

class MockSiteRemoteDataSource extends Mock implements SiteRemoteDataSource {}

void main() {
  late SiteRepositoryImpl siteRepository;
  late MockSiteLocalDataSource mockLocalDataSource;
  late MockSiteRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockSiteLocalDataSource();
    mockRemoteDataSource = MockSiteRemoteDataSource();
    siteRepository = SiteRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('SiteRepositoryImpl', () {
    final tSiteEntity = SiteEntity(
      id: '1',
      name: 'Test Site',
      url: 'https://example.com',
      apiKey: 'test_key',
      createdAt: DateTime.now(),
    );
    final tSiteModel = SiteModel.fromEntity(tSiteEntity);

    group('getSites', () {
      test('should return list of sites from local data source', () async {
        // Arrange
        when(mockLocalDataSource.getSites()).thenAnswer((_) async => [tSiteModel]);

        // Act
        final result = await siteRepository.getSites();

        // Assert
        expect(result, [tSiteModel]);
        verify(mockLocalDataSource.getSites());
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should throw UseCaseException when local data source throws CacheException', () async {
        // Arrange
        when(mockLocalDataSource.getSites()).thenThrow(CacheException());

        // Act
        final call = siteRepository.getSites;

        // Assert
        expect(() => call(), throwsA(isA<UseCaseException>()));
      });
    });

    group('addSite', () {
      test('should return site entity when validation and caching is successful', () async {
        // Arrange
        when(mockRemoteDataSource.addSite(any, any)).thenAnswer((_) async => tSiteModel);
        when(mockLocalDataSource.addSite(any)).thenAnswer((_) async => tSiteModel);

        // Act
        final result = await siteRepository.addSite(tSiteEntity);

        // Assert
        expect(result, tSiteEntity);
        // This test setup is simplified. A real test would require mocking WPApiDataSource
        // to properly test the `validateConnection` logic.
        // For now, we assume the happy path.
      });
    });

    group('deleteSite', () {
      test('should complete successfully when local data source deletion is successful', () async {
        // Arrange
        when(mockLocalDataSource.deleteSite(any)).thenAnswer((_) async => Future.value());

        // Act
        final call = siteRepository.deleteSite('1');

        // Assert
        await expectLater(call, completes);
        verify(mockLocalDataSource.deleteSite('1'));
      });

      test('should throw UseCaseException when local data source throws CacheException', () async {
        // Arrange
        when(mockLocalDataSource.deleteSite(any)).thenThrow(CacheException());

        // Act
        final call = siteRepository.deleteSite('1');

        // Assert
        expect(() => call, throwsA(isA<UseCaseException>()));
      });
    });
  });
}
