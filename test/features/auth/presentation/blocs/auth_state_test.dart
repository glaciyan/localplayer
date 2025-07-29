import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_state.dart';
import 'package:localplayer/features/auth/domain/entities/user_auth.dart';

void main() {
  group('AuthState', () {
    group('AuthSignIn', () {
      test('should create AuthSignIn', () {
        // Act
        final AuthSignIn state = AuthSignIn();

        // Assert
        expect(state, isA<AuthSignIn>());
      });
    });

    group('AuthSignUp', () {
      test('should create AuthSignUp', () {
        // Act
        final AuthSignUp state = AuthSignUp();

        // Assert
        expect(state, isA<AuthSignUp>());
      });
    });

    group('AuthInitial', () {
      test('should create AuthInitial', () {
        // Act
        final AuthInitial state = AuthInitial();

        // Assert
        expect(state, isA<AuthInitial>());
      });
    });

    group('AuthLoading', () {
      test('should create AuthLoading', () {
        // Act
        final AuthLoading state = AuthLoading();

        // Assert
        expect(state, isA<AuthLoading>());
      });
    });

    group('Registered', () {
      test('should create Registered', () {
        // Act
        final Registered state = Registered();

        // Assert
        expect(state, isA<Registered>());
      });
    });

    group('FoundYou', () {
      test('should create FoundYou', () {
        // Act
        final FoundYou state = FoundYou();

        // Assert
        expect(state, isA<FoundYou>());
      });
    });

    group('Authenticated', () {
      test('should create Authenticated with correct user', () {
        // Arrange
        const UserAuth user = UserAuth(id: '1', name: 'testuser', token: 'token123');

        // Act
        final Authenticated state = Authenticated(user);

        // Assert
        expect(state.user, equals(user));
      });

      test('should create equal instances with same values', () {
        // Arrange & Act
        const UserAuth user = UserAuth(id: '1', name: 'testuser', token: 'token123');
        final Authenticated state1 = Authenticated(user);
        final Authenticated state2 = Authenticated(user);

        // Assert
        expect(state1.user, equals(state2.user));
      });
    });

    group('Unauthenticated', () {
      test('should create Unauthenticated', () {
        // Act
        final Unauthenticated state = Unauthenticated();

        // Assert
        expect(state, isA<Unauthenticated>());
      });
    });

    group('AuthError', () {
      test('should create AuthError with correct message', () {
        // Arrange
        const String message = 'Authentication failed';

        // Act
        final AuthError state = AuthError(message);

        // Assert
        expect(state.message, equals(message));
      });

      test('should create equal instances with same values', () {
        // Arrange & Act
        final AuthError state1 = AuthError('Error 1');
        final AuthError state2 = AuthError('Error 1');

        // Assert
        expect(state1.message, equals(state2.message));
      });

      test('should handle empty message', () {
        // Arrange
        const String message = '';

        // Act
        final AuthError state = AuthError(message);

        // Assert
        expect(state.message, equals(message));
      });

      test('should handle long error message', () {
        // Arrange
        const String message = 'This is a very long error message that contains multiple words and should be handled properly by the AuthError state';

        // Act
        final AuthError state = AuthError(message);

        // Assert
        expect(state.message, equals(message));
      });
    });
  });
} 