import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:localplayer/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:localplayer/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:localplayer/core/services/spotify/data/services/config_service.dart';
import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, ConfigService])
void main() {
  group('AuthRepository', () {
    late MockAuthRemoteDataSource mockDataSource;
    late MockConfigService mockConfig;
    late AuthRepository authRepository;

    const String testUsername = 'testuser';
    const String testPassword = 'testpassword';
    const String testNotSecret = 'test_not_secret';
    const String testToken = 'test_token_123';

    setUp(() {
      mockDataSource = MockAuthRemoteDataSource();
      mockConfig = MockConfigService();
      authRepository = AuthRepository(mockDataSource, mockConfig);
    });

    group('signIn', () {
      test('should call data source with correct parameters', () async {
        // Arrange
        when(mockConfig.notSecret).thenReturn(testNotSecret);
        when(mockDataSource.signIn(testUsername, testPassword, testNotSecret))
            .thenAnswer((_) async => <String, dynamic>{'token': testToken});

        // Act
        final result = await authRepository.signIn(testUsername, testPassword);

        // Assert
        verify(mockConfig.notSecret).called(1);
        verify(mockDataSource.signIn(testUsername, testPassword, testNotSecret))
            .called(1);
        expect(result, equals(<String, dynamic>{'token': testToken}));
      });

      test('should throw exception when data source throws', () async {
        // Arrange
        when(mockConfig.notSecret).thenReturn(testNotSecret);
        when(mockDataSource.signIn(testUsername, testPassword, testNotSecret))
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => authRepository.signIn(testUsername, testPassword),
          throwsA(isA<Exception>()),
        );
        verify(mockConfig.notSecret).called(1);
        verify(mockDataSource.signIn(testUsername, testPassword, testNotSecret))
            .called(1);
      });
    });

    group('signUp', () {
      test('should call data source with correct parameters', () async {
        // Arrange
        when(mockConfig.notSecret).thenReturn(testNotSecret);
        when(mockDataSource.signUp(testUsername, testPassword, testNotSecret))
            .thenAnswer((_) async => true);

        // Act
        await authRepository.signUp(testUsername, testPassword);

        // Assert
        verify(mockConfig.notSecret).called(1);
        verify(mockDataSource.signUp(testUsername, testPassword, testNotSecret))
            .called(1);
      });

      test('should throw exception when data source throws', () async {
        // Arrange
        when(mockConfig.notSecret).thenReturn(testNotSecret);
        when(mockDataSource.signUp(testUsername, testPassword, testNotSecret))
            .thenThrow(Exception('Username already exists'));

        // Act & Assert
        expect(
          () => authRepository.signUp(testUsername, testPassword),
          throwsA(isA<Exception>()),
        );
        verify(mockConfig.notSecret).called(1);
        verify(mockDataSource.signUp(testUsername, testPassword, testNotSecret))
            .called(1);
      });
    });

    group('findMe', () {
      test('should call data source with correct bearer token', () async {
        // Arrange
        when(mockDataSource.findMe(testToken))
            .thenAnswer((_) async => <String, dynamic>{'id': '1', 'name': testUsername});

        // Act
        final result = await authRepository.findMe(testToken);

        // Assert
        verify(mockDataSource.findMe(testToken)).called(1);
        expect(result, equals(<String, dynamic>{'id': '1', 'name': testUsername}));
      });

      test('should throw exception when data source throws', () async {
        // Arrange
        when(mockDataSource.findMe(testToken))
            .thenThrow(Exception('Invalid token'));

        // Act & Assert
        expect(
          () => authRepository.findMe(testToken),
          throwsA(isA<Exception>()),
        );
        verify(mockDataSource.findMe(testToken)).called(1);
      });
    });
  });
} 