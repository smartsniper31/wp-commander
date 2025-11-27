import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wp_commander/domain/entities/site_entity.dart';
import 'package:wp_commander/domain/repositories/site_repository.dart';
import 'package:wp_commander/domain/usecases/sites/add_site_usecase.dart';
import 'package:wp_commander/core/errors/failures.dart';

// 1. Create a mock for the repository
class MockSiteRepository extends Mock implements SiteRepository {}

void main() {
  late AddSiteUseCase useCase;
  late MockSiteRepository mockSiteRepository;

  setUp(() {
    mockSiteRepository = MockSiteRepository();
    useCase = AddSiteUseCase(mockSiteRepository);
    registerFallbackValue(SiteEntity(
      id: '1',
      name: 'fallback',
      url: 'http://fallback.com',
      apiKey: 'fb_key',
      createdAt: DateTime.now(),
    ));
  });

  // 2. Prepare test data
  final tParams = AddSiteParams(
    name: 'Test Site',
    url: 'https://example.com',
    apiKey: 'test_key',
  );
  
  final tSiteEntity = SiteEntity(
    id: '1',
    name: 'Test Site',
    url: 'https://example.com',
    apiKey: 'test_key',
    createdAt: DateTime.now(),
  );

  group('AddSiteUseCase', () {
    test(
      'should call repository to add a site and return the site entity on success',
      () async {
        // Arrange
        // 3. Stub the repository method
        when(() => mockSiteRepository.addSite(any())).thenAnswer((_) async => Right(tSiteEntity));

        // Act
        // 4. Execute the use case
        final result = await useCase.execute(tParams);

        // Assert
        // 5. Verify the result and interactions
        expect(result, Right(tSiteEntity));
        
        final captured = verify(() => mockSiteRepository.addSite(captureAny())).captured;
        final capturedSite = captured.first as SiteEntity;

        expect(capturedSite.name, tParams.name);
        expect(capturedSite.url, tParams.url);
        expect(capturedSite.apiKey, tParams.apiKey);
        
        verifyNoMoreInteractions(mockSiteRepository);
      },
    );

    test(
      'should return a failure when repository call fails',
      () async {
        // Arrange
        const tFailure = ServerFailure(message: 'Server Error');
        when(() => mockSiteRepository.addSite(any())).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase.execute(tParams);

        // Assert
        expect(result, const Left(tFailure));
        verify(() => mockSiteRepository.addSite(any()));
        verifyNoMoreInteractions(mockSiteRepository);
      },
    );
  });
}
