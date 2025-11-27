import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wp_commander/core/errors/failures.dart';
import 'package:wp_commander/domain/repositories/site_repository.dart';
import 'package:wp_commander/domain/usecases/sites/validate_site_usecase.dart';

class MockSiteRepository extends Mock implements SiteRepository {}

void main() {
  late ValidateSiteUseCase useCase;
  late MockSiteRepository mockSiteRepository;

  setUp(() {
    mockSiteRepository = MockSiteRepository();
    useCase = ValidateSiteUseCase(mockSiteRepository);
  });

  const tParams = ValidateSiteParams(url: 'https://example.com', apiKey: 'test_key');

  test('should call repository and return true on successful validation', () async {
    // Arrange
    when(() => mockSiteRepository.validateApiKey(url: any(named: 'url'), apiKey: any(named: 'apiKey')))
        .thenAnswer((_) async => const Right(true));

    // Act
    final result = await useCase.execute(tParams);

    // Assert
    expect(result, const Right(true));
    verify(() => mockSiteRepository.validateApiKey(url: tParams.url, apiKey: tParams.apiKey));
    verifyNoMoreInteractions(mockSiteRepository);
  });

  test('should call repository and return false on failed validation', () async {
    // Arrange
    when(() => mockSiteRepository.validateApiKey(url: any(named: 'url'), apiKey: any(named: 'apiKey')))
        .thenAnswer((_) async => const Right(false));

    // Act
    final result = await useCase.execute(tParams);

    // Assert
    expect(result, const Right(false));
    verify(() => mockSiteRepository.validateApiKey(url: tParams.url, apiKey: tParams.apiKey));
    verifyNoMoreInteractions(mockSiteRepository);
  });

  test('should return a failure when the repository call fails', () async {
    // Arrange
    const tFailure = ServerFailure(message: 'Server Error');
    when(() => mockSiteRepository.validateApiKey(url: any(named: 'url'), apiKey: any(named: 'apiKey')))
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase.execute(tParams);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockSiteRepository.validateApiKey(url: tParams.url, apiKey: tParams.apiKey));
    verifyNoMoreInteractions(mockSiteRepository);
  });
}
