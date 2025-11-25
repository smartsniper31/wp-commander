import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/domain/repositories/site_repository.dart';
import 'package:wp_commander/domain/usecases/site/add_site_usecase.dart';

import 'add_site_usecase_test.mocks.dart';

@GenerateMocks([SiteRepository])
void main() {
  late AddSiteUseCase addSiteUseCase;
  late MockSiteRepository mockSiteRepository;

  setUp(() {
    mockSiteRepository = MockSiteRepository();
    addSiteUseCase = AddSiteUseCase(mockSiteRepository);
  });

  final tSite = SiteEntity(
    id: '1',
    name: 'Test Site',
    url: 'https://example.com',
    apiKey: 'test_key',
    createdAt: DateTime.now(),
  );

  group('AddSiteUseCase', () {
    test('should add site and return it when validation is successful', () async {
      // Arrange
      final params = AddSiteParams(site: tSite);

      when(mockSiteRepository.validateApiKey(url: tSite.url, apiKey: tSite.apiKey))
          .thenAnswer((_) async => const Right(true));

      when(mockSiteRepository.addSite(any))
          .thenAnswer((_) async => Right(tSite));

      // Act
      final result = await addSiteUseCase.execute(params);

      // Assert
      expect(result, Right(tSite));
      verify(mockSiteRepository.validateApiKey(url: tSite.url, apiKey: tSite.apiKey));
      verify(mockSiteRepository.addSite(tSite));
    });

    test('should return a failure when validation fails', () async {
      // Arrange
      final params = AddSiteParams(site: tSite);

      when(mockSiteRepository.validateApiKey(url: tSite.url, apiKey: tSite.apiKey))
          .thenAnswer((_) async => const Right(false));

      // Act
      final result = await addSiteUseCase.execute(params);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (success) => fail('should have returned a failure'),
      );
      verify(mockSiteRepository.validateApiKey(url: tSite.url, apiKey: tSite.apiKey));
      verifyNever(mockSiteRepository.addSite(any));
    });
  });
}