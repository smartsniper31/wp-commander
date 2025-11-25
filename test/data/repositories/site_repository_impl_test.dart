import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wp_commander/data/repositories/site_repository_impl.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/data/datasources/local/site_local_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:wp_commander/core/errors/failures.dart';

import 'site_repository_impl_test.mocks.dart';

@GenerateMocks([SiteLocalDataSource])
void main() {
  late SiteRepositoryImpl siteRepository;
  late MockSiteLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockSiteLocalDataSource();
    siteRepository = SiteRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('SiteRepositoryImpl', () {
    final tSite = SiteEntity(
      id: '1',
      name: 'Test Site',
      url: 'https://example.com',
      apiKey: 'test_key',
      createdAt: DateTime.now(),
    );

    test('should get sites from cache', () async {
      // Arrange
      when(mockLocalDataSource.getSites()).thenAnswer((_) async => [tSite]);

      // Act
      final result = await siteRepository.getSites();

      // Assert
      expect(result.isRight(), true);
      result.fold((l) => fail('test failed'), (r) => expect(r.length, 1));
      verify(mockLocalDataSource.getSites());
    });

    test('should add site successfully', () async {
      // Arrange
      when(mockLocalDataSource.cacheSite(any)).thenAnswer((_) async => tSite);
      // N.B. We are not testing the remote validation here, so we assume it passes
      // and let the addSite method proceed to cache.

      // Act
      final result = await siteRepository.addSite(tSite);

      // Assert
      expect(result.isRight(), true);
      verify(mockLocalDataSource.cacheSite(tSite));
    });

    test('should delete site successfully', () async {
      // Arrange
      when(mockLocalDataSource.deleteSite(any)).thenAnswer((_) async => unit);

      // Act
      final result = await siteRepository.deleteSite('1');

      // Assert
      expect(result.isRight(), true);
      verify(mockLocalDataSource.deleteSite('1'));
    });
  });
}
