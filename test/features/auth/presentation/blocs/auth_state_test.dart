import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_state.dart';
import 'package:localplayer/features/auth/domain/entities/user_auth.dart';

void main() {
  group('AuthState', () {
    group('AuthSignIn', () {
      test('should create AuthSignIn', () {
        // Act
        final state = AuthSignIn();

        // Assert
        expect(state, isA<AuthSignIn>());
      });
    });

    group('AuthSignUp', () {
      test('should create AuthSignUp', () {
        // Act
        final state = AuthSignUp();

        // Assert
        expect(state, isA<AuthSignUp>());
      });
    });

    group('AuthInitial', () {
      test('should create AuthInitial', () {
        // Act
        final state = AuthInitial();

        // Assert
        expect(state, isA<AuthInitial>());
      });
    });

    group('AuthLoading', () {
      test('should create AuthLoading', () {
        // Act
        final state = AuthLoading();

        // Assert
        expect(state, isA<AuthLoading>());
      });
    });

    group('Registered', () {
      test('should create Registered', () {
        // Act
        final state = Registered();

        // Assert
        expect(state, isA<Registered>());
      });
    });

    group('FoundYou', () {
      test('should create FoundYou', () {
        // Act
        final state = FoundYou();

        // Assert
        expect(state, isA<FoundYou>());
      });
    });

    group('Authenticated', () {
      test('should create Authenticated with correct user', () {
        // Arrange
        const user = UserAuth(id: '1', name: 'testuser', token: 'token123');

        // Act
        final state = Authenticated(user);

        // Assert
        expect(state.user, equals(user));
      });

      test('should create equal instances with same values', () {
        // Arrange & Act
        const user = UserAuth(id: '1', name: 'testuser', token: 'token123');
        final state1 = Authenticated(user);
        final state2 = Authenticated(user);

        // Assert
        expect(state1.user, equals(state2.user));
      });
    });

    group('Unauthenticated', () {
      test('should create Unauthenticated', () {
        // Act
        final state = Unauthenticated();

        // Assert
        expect(state, isA<Unauthenticated>());
      });
    });

    group('AuthError', () {
      test('should create AuthError with correct message', () {
        // Arrange
        const String message = 'Authentication failed';

        // Act
        final state = AuthError(message);

        // Assert
        expect(state.message, equals(message));
      });

      test('should create equal instances with same values', () {
        // Arrange & Act
        final state1 = AuthError('Error 1');
        final state2 = AuthError('Error 1');

        // Assert
        expect(state1.message, equals(state2.message));
      });

      test('should handle empty message', () {
        // Arrange
        const String message = '';

        // Act
        final state = AuthError(message);

        // Assert
        expect(state.message, equals(message));
      });

      test('should handle long error message', () {
        // Arrange
        const String message = 'This is a very long error message that contains multiple words and should be handled properly by the AuthError state';

        // Act
        final state = AuthError(message);

        // Assert
        expect(state.message, equals(message));
      });
    });
  });
} 