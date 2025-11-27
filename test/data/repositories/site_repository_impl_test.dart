import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wp_commander/core/errors/exceptions.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/data/datasources/local/site_local_datasource.dart';
import 'package:wp_commander/data/datasources/site_remote_datasource.dart';
import 'package:wp_commander/data/models/site_model.dart';
import 'package:wp_commander/data/repositories/site_repository_impl.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';

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

  final tSiteEntity = SiteEntity(
    id: '1',
    name: 'Test Site',
    url: 'https://example.com',
    apiKey: 'test_key',
    createdAt: DateTime.now(),
  );
  final tSiteModel = SiteModel.fromEntity(tSiteEntity);

  group('SiteRepositoryImpl', () {
    group('getSites', () {
      test(
          'should return Right with list of sites from local data source when call is successful',
          () async {
        // Arrange
        when(mockLocalDataSource.getSites())
            .thenAnswer((_) async => [tSiteModel]);

        // Act
        final result = await siteRepository.getSites();

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right, [tSiteEntity]);
        verify(mockLocalDataSource.getSites());
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test(
          'should return Left with CacheFailure when local data source throws CacheException',
          () async {
        // Arrange
        when(mockLocalDataSource.getSites()).thenThrow(CacheException());

        // Act
        final result = await siteRepository.getSites();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left, isA<CacheFailure>());
        verify(mockLocalDataSource.getSites());
      });
    });

    group('addSite', () {
      test(
          'should return Right with site entity when validation and caching is successful',
          () async {
        // Arrange
        when(mockRemoteDataSource.addSite(
                tSiteEntity.url, tSiteEntity.apiKey))
            .thenAnswer((_) async => tSiteModel);
        when(mockLocalDataSource.addSite(tSiteModel))
            .thenAnswer((_) => Future.value(tSiteModel));

        // Act
        final result = await siteRepository.addSite(tSiteEntity);

        // Assert
        expect(result.isRight, isTrue);
        expect(result.right, tSiteEntity);
        verify(mockRemoteDataSource.addSite(
            tSiteEntity.url, tSiteEntity.apiKey));
        verify(mockLocalDataSource.addSite(tSiteModel));
      });
    });

    group('deleteSite', () {
      const tSiteId = '1';
      test(
          'should return Right(null) when local data source deletion is successful',
          () async {
        // Arrange
        when(mockLocalDataSource.deleteSite(tSiteId))
            .thenAnswer((_) => Future.value());

        // Act
        final result = await siteRepository.deleteSite(tSiteId);

        // Assert
        expect(result.isRight, isTrue);
        verify(mockLocalDataSource.deleteSite(tSiteId));
      });

      test(
          'should return Left with CacheFailure when local data source throws CacheException',
          () async {
        // Arrange
        when(mockLocalDataSource.deleteSite(tSiteId))
            .thenThrow(CacheException());

        // Act
        final result = await siteRepository.deleteSite(tSiteId);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.left, isA<CacheFailure>());
        verify(mockLocalDataSource.deleteSite(tSiteId));
      });
    });
  });
}
