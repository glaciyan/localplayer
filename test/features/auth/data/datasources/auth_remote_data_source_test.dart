import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:localplayer/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'auth_remote_data_source_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  group('AuthRemoteDataSource', () {
    late MockApiClient mockApiClient;
    late AuthRemoteDataSource authDataSource;

    const String testUsername = 'testuser';
    const String testPassword = 'testpassword';
    const String testNotSecret = 'test_not_secret';
    const String testToken = 'test_token_123';

    setUp(() {
      mockApiClient = MockApiClient();
      authDataSource = AuthRemoteDataSource(mockApiClient);
    });

    group('signIn', () {
      test('should make POST request to /user/login with correct data', () async {
        // Arrange
        final expectedData = <String, String>{
          'name': testUsername,
          'password': testPassword,
        };
        final expectedOptions = Options(
          headers: <String, String>{'not_secret': testNotSecret},
        );
        final expectedResponse = Response<dynamic>(
          data: <String, dynamic>{'token': testToken},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/user/login'),
        );

        when(mockApiClient.post(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await authDataSource.signIn(testUsername, testPassword, testNotSecret);

        // Assert
        verify(mockApiClient.post(
          '/user/login',
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).called(1);
        expect(result, equals(<String, dynamic>{'token': testToken}));
      });

      test('should throw exception when API call fails', () async {
        // Arrange
        when(mockApiClient.post(
          '/user/login',
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/user/login'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/user/login'),
          ),
        ));

        // Act & Assert
        expect(
          () => authDataSource.signIn(testUsername, testPassword, testNotSecret),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('signUp', () {
      test('should make POST request to /user/signup with correct data', () async {
        // Arrange
        final expectedData = <String, String>{
          'name': testUsername,
          'password': testPassword,
        };
        final expectedOptions = Options(
          headers: <String, String>{'not_secret': testNotSecret},
        );
        final expectedResponse = Response<dynamic>(
          data: null,
          statusCode: 201,
          requestOptions: RequestOptions(path: '/user/signup'),
        );

        when(mockApiClient.post(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => expectedResponse);

        // Act
        await authDataSource.signUp(testUsername, testPassword, testNotSecret);

        // Assert
        verify(mockApiClient.post(
          '/user/signup',
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).called(1);
      });

      test('should throw exception when API call fails', () async {
        // Arrange
        when(mockApiClient.post(
          '/user/signup',
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/user/signup'),
          response: Response(
            statusCode: 409,
            requestOptions: RequestOptions(path: '/user/signup'),
          ),
        ));

        // Act & Assert
        expect(
          () => authDataSource.signUp(testUsername, testPassword, testNotSecret),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('findMe', () {
      test('should make GET request to /profile/me with correct authorization header', () async {
        final expectedOptions = Options(headers: <String, String>{'Authorization': 'Bearer $testToken'});
        final expectedResponse = Response<dynamic>(
          data: <String, dynamic>{'id': '1', 'name': testUsername},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/profile/me'),
        );

        when(mockApiClient.get(
          '/profile/me',
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => expectedResponse);

        final result = await authDataSource.findMe(testToken);

        verify(mockApiClient.get(
          '/profile/me',
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        )).called(1);

        expect(result, equals(expectedResponse));
      });

      test('should throw exception when API call fails', () async {
        // Arrange
        when(mockApiClient.get(
          '/profile/me',
          options: anyNamed('options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/profile/me'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/profile/me'),
          ),
        ));

        // Act & Assert
        expect(
          () => authDataSource.findMe(testToken),
          throwsA(isA<DioException>()),
        );
      });
    });
  });
} 