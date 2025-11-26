import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wp_commander/domain/repositories/site_repository.dart';
import 'package:wp_commander/domain/usecases/sites/validate_site_usecase.dart';
import 'package:wp_commander/core/errors/exceptions.dart';

class MockSiteRepository extends Mock implements SiteRepository {}

void main() {
  late ValidateSiteUseCase validateSiteUseCase;
  late MockSiteRepository mockSiteRepository;

  setUp(() {
    mockSiteRepository = MockSiteRepository();
    validateSiteUseCase = ValidateSiteUseCase(mockSiteRepository);
  });

  group('ValidateSiteUseCase', () {
    const tParams = ValidateSiteParams(
      url: 'https://example.com',
      apiKey: 'valid_api_key_123',
    );

    test('should return true when API key is valid', () async {
      // Arrange
      when(mockSiteRepository.validateApiKey(url: tParams.url, apiKey: tParams.apiKey))
          .thenAnswer((_) async => true);

      // Act
      final result = await validateSiteUseCase.execute(tParams);

      // Assert
      expect(result, true);
      verify(mockSiteRepository.validateApiKey(url: tParams.url, apiKey: tParams.apiKey));
    });

    test('should return false when API key is invalid', () async {
      // Arrange
      when(mockSiteRepository.validateApiKey(url: tParams.url, apiKey: tParams.apiKey))
          .thenAnswer((_) async => false);

      // Act
      final result = await validateSiteUseCase.execute(tParams);

      // Assert
      expect(result, false);
      verify(mockSiteRepository.validateApiKey(url: tParams.url, apiKey: tParams.apiKey));
    });

    test('should throw UseCaseException when repository throws an exception', () async {
      // Arrange
      when(mockSiteRepository.validateApiKey(url: tParams.url, apiKey: tParams.apiKey))
          .thenThrow(RepositoryException(message: 'Network error'));

      // Act
      final call = validateSiteUseCase.execute;

      // Assert
      expect(() => call(tParams), throwsA(isA<RepositoryException>()));
    });
  });
}
