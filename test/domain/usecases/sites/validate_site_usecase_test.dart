import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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

  const tUrl = 'https://example.com';
  const tApiKey = 'test_key';

  test('should return true when validation is successful', () async {
    // Arrange
    when(mockSiteRepository.validateApiKey(any, any, url: '', apiKey: '')).thenAnswer((_) async => true);

    // Act
    final result = await useCase.execute(const ValidateSiteParams(url: tUrl, apiKey: tApiKey));

    // Assert
    expect(result, true);
    verify(mockSiteRepository.validateApiKey(tUrl, tApiKey, url: '', apiKey: ''));
    verifyNoMoreInteractions(mockSiteRepository);
  });

  test('should return false when validation fails', () async {
    // Arrange
    when(mockSiteRepository.validateApiKey(any, any, url: '', apiKey: '')).thenAnswer((_) async => false);

    // Act
    final result = await useCase.execute(const ValidateSiteParams(url: tUrl, apiKey: tApiKey));

    // Assert
    expect(result, false);
    verify(mockSiteRepository.validateApiKey(tUrl, tApiKey, url: '', apiKey: ''));
    verifyNoMoreInteractions(mockSiteRepository);
  });
}
