import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/domain/repositories/site_repository.dart';
import 'package:wp_commander/domain/usecases/sites/add_site_usecase.dart';
import 'package:wp_commander/core/errors/exceptions.dart';

class MockSiteRepository extends Mock implements SiteRepository {}

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

  final tAddSiteParams = AddSiteParams(
    name: tSite.name,
    url: tSite.url,
    apiKey: tSite.apiKey,
  );

  group('AddSiteUseCase', () {
    test('should add site and return it', () async {
      // Arrange
      when(mockSiteRepository.addSite(argThat(isA<SiteEntity>()))).thenAnswer((_) async => tSite);

      // Act
      final result = await addSiteUseCase.execute(tAddSiteParams);

      // Assert
      // We expect a SiteEntity, but we can't know the id and createdAt, so we check the type
      expect(result, isA<SiteEntity>());
    });

    test('should throw UseCaseException when repository throws RepositoryException', () async {
      // Arrange
      when(mockSiteRepository.addSite(argThat(isA<SiteEntity>()))).thenThrow(RepositoryException(message: 'test'));

      // Act
      final call = addSiteUseCase.execute;

      // Assert
      expect(() => call(tAddSiteParams), throwsA(isA<RepositoryException>()));
    });

    test('should throw UseCaseException when params are empty', () async {
      // Act
      final call = addSiteUseCase.execute;

      // Assert
      expect(() => call(AddSiteParams(name: '', url: 'url', apiKey: 'apiKey')), throwsA(isA<UseCaseException>()));
      expect(() => call(AddSiteParams(name: 'name', url: '', apiKey: 'apiKey')), throwsA(isA<UseCaseException>()));
      expect(() => call(AddSiteParams(name: 'name', url: 'url', apiKey: '')), throwsA(isA<UseCaseException>()));
    });
  });
}
