import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/domain/repositories/site_repository.dart';
import 'package:wp_commander/domain/usecases/site/validate_site_usecase.dart';

import 'validate_site_usecase_test.mocks.dart';

@GenerateMocks([SiteRepository])
void main() {
  late ValidateSiteUseCase validateSiteUseCase;
  late MockSiteRepository mockSiteRepository;

  setUp(() {
    mockSiteRepository = MockSiteRepository();
    validateSiteUseCase = ValidateSiteUseCase(mockSiteRepository);
  });

  group('ValidateSiteUseCase', () {
    test('should return true when API key is valid', () async {
      // Arrange
      const params = ValidateSiteParams(
        url: 'https://example.com',
        apiKey: 'valid_api_key_123',
      );

      when(mockSiteRepository.validateApiKey(
              url: params.url, apiKey: params.apiKey))
          .thenAnswer((_) async => true);

      // Act
      final result = await validateSiteUseCase.execute(params);

      // Assert
      expect(result.isRight, true);
      result.fold((l) => fail('test failed'), (r) => expect(r, true));
      verify(mockSiteRepository.validateApiKey(
          url: params.url, apiKey: params.apiKey));
    });

    test('should return false when API key is invalid', () async {
      // Arrange
      const params = ValidateSiteParams(
        url: 'https://example.com',
        apiKey: 'invalid_api_key',
      );

      when(mockSiteRepository.validateApiKey(
              url: params.url, apiKey: params.apiKey))
          .thenAnswer((_) async => false);

      // Act
      final result = await validateSiteUseCase.execute(params);

      // Assert
      expect(result.isRight, true);
      result.fold((l) => fail('test failed'), (r) => expect(r, false));
      verify(mockSiteRepository.validateApiKey(
          url: params.url, apiKey: params.apiKey));
    });

    test('should return error when repository throws exception', () async {
      // Arrange
      const params = ValidateSiteParams(
        url: 'https://example.com',
        apiKey: 'valid_key',
      );

      when(mockSiteRepository.validateApiKey(
              url: params.url, apiKey: params.apiKey))
          .thenThrow(Exception('Network error'));

      // Act
      final result = await validateSiteUseCase.execute(params);

      // Assert
      expect(result.isLeft, true);
      result.fold(
          (l) => expect(
              l.message, contains('Erreur lors de la validation du site')),
          (r) => fail('should have returned a failure'));
    });
  });
}
