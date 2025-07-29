import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_event.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_state.dart';
import 'package:localplayer/features/auth/data/IAuthRepository.dart';
import 'package:localplayer/core/services/geolocator/geolocator_interface.dart';
import 'package:localplayer/core/services/presence/presence_interface.dart';
import 'package:localplayer/core/network/no_connection_exception.dart';
import 'auth_bloc_test.mocks.dart';

@GenerateMocks(<Type>[
  IAuthRepository,
  IGeolocatorService,
  IPresenceService,
  SharedPreferences,
])
void main() {
  group('AuthBloc', () {
    late MockIAuthRepository mockAuthRepository;
    late MockIGeolocatorService mockGeolocatorService;
    late MockIPresenceService mockPresenceService;
    late MockSharedPreferences mockSharedPreferences;
    late AuthBloc authBloc;

    const String testUsername = 'testuser';
    const String testPassword = 'testpassword';
    const String testToken = 'test_token_123';
    const double testLatitude = 47.6596;
    const double testLongitude = 9.1753;

    setUp(() {
      mockAuthRepository = MockIAuthRepository();
      mockGeolocatorService = MockIGeolocatorService();
      mockPresenceService = MockIPresenceService();
      mockSharedPreferences = MockSharedPreferences();

      authBloc = AuthBloc(
        authRepository: mockAuthRepository,
        geolocatorService: mockGeolocatorService,
        presenceService: mockPresenceService,
      );
    });

    tearDown(() {
      authBloc.close();
    });

    group('SignInRequested', () {
      test('initial state is AuthInitial', () {
        expect(authBloc.state, isA<AuthInitial>());
      });

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when sign in succeeds',
        build: () {
          when(mockGeolocatorService.getCurrentLocation()).thenAnswer(
            (_) async => Position(
              latitude: testLatitude,
              longitude: testLongitude,
              timestamp: DateTime.now(),
              accuracy: 10.0,
              altitude: 0.0,
              heading: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0,
              altitudeAccuracy: 1.0,
              headingAccuracy: 1.0,
            ),
          );
          when(mockAuthRepository.signIn(testUsername, testPassword)).thenAnswer(
            (_) async => <String, dynamic>{'token': testToken},
          );
          when(mockPresenceService.updateLocation(
            latitude: testLatitude,
            longitude: testLongitude,
            fakingRadiusMeters: 100.0,
          )).thenAnswer((_) async => true);
          when(mockSharedPreferences.setString('token', testToken))
              .thenAnswer((_) async => true);
          when(mockSharedPreferences.setDouble('user_latitude', testLatitude))
              .thenAnswer((_) async => true);
          when(mockSharedPreferences.setDouble('user_longitude', testLongitude))
              .thenAnswer((_) async => true);
          // Mock SharedPreferences.getInstance()
          SharedPreferences.setMockInitialValues(<String, Object>{});
          return authBloc;
        },
        act: (final AuthBloc bloc) => bloc.add(SignInRequested(testUsername, testPassword)),
        expect: () => <TypeMatcher<AuthState>>[
          isA<AuthLoading>(),
          isA<Authenticated>(),
        ],
        verify: (_) {
          verify(mockGeolocatorService.getCurrentLocation()).called(1);
          verify(mockAuthRepository.signIn(testUsername, testPassword)).called(1);
          verify(mockPresenceService.updateLocation(
            latitude: testLatitude,
            longitude: testLongitude,
            fakingRadiusMeters: 100.0,
          )).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when geolocator fails',
        build: () {
          when(mockGeolocatorService.getCurrentLocation()).thenThrow(
            Exception('Location permission denied'),
          );

          return authBloc;
        },
        act: (final AuthBloc bloc) => bloc.add(SignInRequested(testUsername, testPassword)),
        expect: () => <TypeMatcher<AuthState>>[
          isA<AuthLoading>(),
          isA<AuthError>(),
        ],
        verify: (_) {
          verify(mockGeolocatorService.getCurrentLocation()).called(1);
          verifyNever(mockAuthRepository.signIn(any, any));
          verifyNever(mockPresenceService.updateLocation(
            latitude: anyNamed('latitude'),
            longitude: anyNamed('longitude'),
            fakingRadiusMeters: anyNamed('fakingRadiusMeters'),
          ));
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when auth repository fails',
        build: () {
          when(mockGeolocatorService.getCurrentLocation()).thenAnswer(
            (_) async => Position(
              latitude: testLatitude,
              longitude: testLongitude,
              timestamp: DateTime.now(),
              accuracy: 10.0,
              altitude: 0.0,
              heading: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0,
              altitudeAccuracy: 1.0,
              headingAccuracy: 1.0,
            ),
          );
          when(mockAuthRepository.signIn(testUsername, testPassword)).thenThrow(
            Exception('Invalid credentials'),
          );

          return authBloc;
        },
        act: (final AuthBloc bloc) => bloc.add(SignInRequested(testUsername, testPassword)),
        expect: () => <TypeMatcher<AuthState>>[
          isA<AuthLoading>(),
          isA<AuthError>(),
        ],
        verify: (_) {
          verify(mockGeolocatorService.getCurrentLocation()).called(1);
          verify(mockAuthRepository.signIn(testUsername, testPassword)).called(1);
          verifyNever(mockPresenceService.updateLocation(
            latitude: anyNamed('latitude'),
            longitude: anyNamed('longitude'),
            fakingRadiusMeters: anyNamed('fakingRadiusMeters'),
          ));
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when presence service fails',
        build: () {
          when(mockGeolocatorService.getCurrentLocation()).thenAnswer(
            (_) async => Position(
              latitude: testLatitude,
              longitude: testLongitude,
              timestamp: DateTime.now(),
              accuracy: 10.0,
              altitude: 0.0,
              heading: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0,
              altitudeAccuracy: 1.0,
              headingAccuracy: 1.0,
            ),
          );
          when(mockAuthRepository.signIn(testUsername, testPassword)).thenAnswer(
            (_) async => <String, dynamic>{'token': testToken},
          );
          when(mockPresenceService.updateLocation(
            latitude: testLatitude,
            longitude: testLongitude,
            fakingRadiusMeters: 100.0,
          )).thenThrow(Exception('Presence update failed'));
          when(mockSharedPreferences.setString('token', testToken))
              .thenAnswer((_) async => true);
          return authBloc;
        },
        act: (final AuthBloc bloc) => bloc.add(SignInRequested(testUsername, testPassword)),
        expect: () => <TypeMatcher<AuthState>>[
          isA<AuthLoading>(),
          isA<AuthError>(),
        ],
        verify: (_) {
          verify(mockGeolocatorService.getCurrentLocation()).called(1);
          verify(mockAuthRepository.signIn(testUsername, testPassword)).called(1);
          verify(mockPresenceService.updateLocation(
            latitude: testLatitude,
            longitude: testLongitude,
            fakingRadiusMeters: 100.0,
          )).called(1);
        },
      );
    });

    group('SignUpRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Registered] when sign up succeeds',
        build: () {
          when(mockAuthRepository.signUp(testUsername, testPassword)).thenAnswer(
            (_) async => <String, dynamic>{'message': 'User registered successfully'},
          );

          return authBloc;
        },
        act: (final AuthBloc bloc) => bloc.add(SignUpRequested(testUsername, testPassword)),
        expect: () => <TypeMatcher<AuthState>>[
          isA<AuthLoading>(),
          isA<Registered>(),
        ],
        verify: (_) {
          verify(mockAuthRepository.signUp(testUsername, testPassword)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when sign up fails with NoConnectionException',
        build: () {
          when(mockAuthRepository.signUp(testUsername, testPassword))
              .thenThrow(NoConnectionException());

          return authBloc;
        },
        act: (final AuthBloc bloc) => bloc.add(SignUpRequested(testUsername, testPassword)),
        expect: () => <TypeMatcher<AuthState>>[
          isA<AuthLoading>(),
          isA<AuthError>(),
        ],
        verify: (_) {
          verify(mockAuthRepository.signUp(testUsername, testPassword)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when sign up fails with other exception',
        build: () {
          when(mockAuthRepository.signUp(testUsername, testPassword))
              .thenThrow(Exception('Registration failed'));

          return authBloc;
        },
        act: (final AuthBloc bloc) => bloc.add(SignUpRequested(testUsername, testPassword)),
        expect: () => <TypeMatcher<AuthState>>[
          isA<AuthLoading>(),
          isA<AuthError>(),
        ],
        verify: (_) {
          verify(mockAuthRepository.signUp(testUsername, testPassword)).called(1);
        },
      );
    });

    // group('FindMeRequested', () {
    //   blocTest<AuthBloc, AuthState>(
    //     'emits [AuthLoading, FoundYou] when find me succeeds',
    //     build: () {
    //       // Set up SharedPreferences mock
    //       SharedPreferences.setMockInitialValues({'token': testToken});
    //       when(mockAuthRepository.findMe(testToken)).thenAnswer((_) async => true);

    //       return authBloc;
    //     },
    //     act: (bloc) => bloc.add(FindMeRequested()),
    //     expect: () => [
    //       isA<AuthLoading>(),
    //       isA<FoundYou>(),
    //     ],
    //     verify: (_) {
    //       verify(mockAuthRepository.findMe(testToken)).called(1);
    //     },
    //   );

    //   blocTest<AuthBloc, AuthState>(
    //     'emits [AuthLoading, AuthError] when token is null',
    //     build: () {
    //       // Set up SharedPreferences mock with null token
    //       SharedPreferences.setMockInitialValues({});

    //       return authBloc;
    //     },
    //     act: (bloc) => bloc.add(FindMeRequested()),
    //     expect: () => [
    //       isA<AuthLoading>(),
    //       isA<AuthError>(),
    //     ],
    //     verify: (_) {
    //       verifyNever(mockAuthRepository.findMe(any));
    //     },
    //   );

    //   blocTest<AuthBloc, AuthState>(
    //     'emits [AuthLoading, AuthError] when token is not a string',
    //     build: () {
    //       // Set up SharedPreferences mock with non-string token
    //       SharedPreferences.setMockInitialValues({'token': 123});

    //       return authBloc;
    //     },
    //     act: (bloc) => bloc.add(FindMeRequested()),
    //     expect: () => [
    //       isA<AuthLoading>(),
    //       isA<AuthError>(),
    //     ],
    //     verify: (_) {
    //       verifyNever(mockAuthRepository.findMe(any));
    //     },
    //   );

    //   blocTest<AuthBloc, AuthState>(
    //     'emits [AuthLoading, AuthError] when find me fails with NoConnectionException',
    //     build: () {
    //       SharedPreferences.setMockInitialValues({'token': testToken});
    //       when(mockAuthRepository.findMe(testToken)).thenThrow(NoConnectionException());

    //       return authBloc;
    //     },
    //     act: (bloc) => bloc.add(FindMeRequested()),
    //     expect: () => [
    //       isA<AuthLoading>(),
    //       isA<AuthError>(),
    //     ],
    //     verify: (_) {
    //       verify(mockAuthRepository.findMe(testToken)).called(1);
    //     },
    //   );

    //   blocTest<AuthBloc, AuthState>(
    //     'emits [AuthLoading, AuthError] when find me fails with other exception',
    //     build: () {
    //       SharedPreferences.setMockInitialValues({'token': testToken});
    //       when(mockAuthRepository.findMe(testToken)).thenThrow(Exception('Invalid token'));

    //       return authBloc;
    //     },
    //     act: (bloc) => bloc.add(FindMeRequested()),
    //     expect: () => [
    //       isA<AuthLoading>(),
    //       isA<AuthError>(),
    //     ],
    //     verify: (_) {
    //       verify(mockAuthRepository.findMe(testToken)).called(1);
    //     },
    //   );
    // });
  });
} 