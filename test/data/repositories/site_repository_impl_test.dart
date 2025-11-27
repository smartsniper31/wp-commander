import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wp_commander/core/errors/exceptions.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/data/datasources/local/site_local_datasource.dart';
import 'package:wp_commander/data/datasources/site_remote_datasource.dart';
import 'package:wp_commander/data/models/site_model.dart';
import 'package:wp_commander/data/repositories/site_repository_impl.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';

// 1. Create Mocks with Mocktail
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
    // 2. Register fallback values for any() matchers
    registerFallbackValue(
      SiteModel.fromEntity(
        SiteEntity(
          id: '1',
          name: 'fallback',
          url: 'http://fallback.com',
          apiKey: 'fb_key',
          createdAt: DateTime.now(),
        ),
      ),
    );
  });

  // Create a fixed date for tests
  final tDate = DateTime(2023, 1, 1);
  final tSiteEntity = SiteEntity(
    id: '1',
    name: 'Test Site',
    url: 'https://example.com',
    apiKey: 'test_key',
    createdAt: tDate,
  );
  final tSiteModel = SiteModel.fromEntity(tSiteEntity);

  group('SiteRepositoryImpl', () {
    group('getSites', () {
      test(
          'should return Right with list of sites from local data source when call is successful',
          () async {
        // Arrange
        when(() => mockLocalDataSource.getSites())
            .thenAnswer((_) async => [tSiteModel]);

        // Act
        final result = await siteRepository.getSites();

        // Assert
        expect(result.isRight, isTrue);
        // Use collection matcher for list comparison
        expect(result.right, orderedEquals([tSiteEntity]));
        verify(() => mockLocalDataSource.getSites());
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test(
          'should return Left with CacheFailure when local data source throws CacheException',
          () async {
        // Arrange
        when(() => mockLocalDataSource.getSites()).thenThrow(CacheException());

        // Act
        final result = await siteRepository.getSites();

        // Assert
        expect(result, isA<Left>());
        expect(result.left, isA<CacheFailure>());
        verify(() => mockLocalDataSource.getSites());
      });
    });

    group('addSite', () {
      test(
          'should return Right with site entity when validation and caching is successful',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.validateConnection(
            any(), any())).thenAnswer((_) async => true);
        when(() => mockLocalDataSource.addSite(any()))
            .thenAnswer((_) async => tSiteModel);

        // Act
        final result = await siteRepository.addSite(tSiteEntity);

        // Assert
        expect(result, Right(tSiteEntity));
        verify(() => mockRemoteDataSource.validateConnection(
            tSiteEntity.url, tSiteEntity.apiKey));
        verify(() => mockLocalDataSource.addSite(tSiteModel));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test(
          'should return Left with InvalidApiKeyFailure when validation fails',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.validateConnection(
            any(), any())).thenAnswer((_) async => false);

        // Act
        final result = await siteRepository.addSite(tSiteEntity);

        // Assert
        expect(result, isA<Left>());
        expect(result.left, isA<InvalidApiKeyFailure>());
        verify(() => mockRemoteDataSource.validateConnection(
            tSiteEntity.url, tSiteEntity.apiKey));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
      });

      test(
          'should return Left with ServerFailure when validation throws ServerException',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.validateConnection(
            any(), any())).thenThrow(ServerException());

        // Act
        final result = await siteRepository.addSite(tSiteEntity);

        // Assert
        expect(result, isA<Left>());
        expect(result.left, isA<ServerFailure>());
        verify(() => mockRemoteDataSource.validateConnection(
            tSiteEntity.url, tSiteEntity.apiKey));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
      });
    });

    group('deleteSite', () {
      const tSiteId = '1';
      test(
          'should return Right(null) when local data source deletion is successful',
          () async {
        // Arrange
        when(() => mockLocalDataSource.deleteSite(any()))
            .thenAnswer((_) => Future.value());

        // Act
        final result = await siteRepository.deleteSite(tSiteId);

        // Assert
        expect(result, const Right(null));
        verify(() => mockLocalDataSource.deleteSite(tSiteId));
      });

      test(
          'should return Left with CacheFailure when local data source throws CacheException',
          () async {
        // Arrange
        when(() => mockLocalDataSource.deleteSite(any()))
            .thenThrow(CacheException());

        // Act
        final result = await siteRepository.deleteSite(tSiteId);

        // Assert
        expect(result, isA<Left>());
        expect(result.left, isA<CacheFailure>());
        verify(() => mockLocalDataSource.deleteSite(tSiteId));
      });
    });
  });
}
