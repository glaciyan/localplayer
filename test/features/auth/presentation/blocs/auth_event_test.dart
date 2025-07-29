import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_event.dart';
import 'package:localplayer/features/auth/domain/entities/user_auth.dart';

void main() {
  group('AuthEvent', () {
    group('SignInRequested', () {
      test('should create SignInRequested with correct values', () {
        // Arrange
        const String name = 'testuser';
        const String password = 'testpassword';

        // Act
        final event = SignInRequested(name, password);

        // Assert
        expect(event.name, equals(name));
        expect(event.password, equals(password));
      });

      test('should create equal instances with same values', () {
        // Arrange & Act
        final event1 = SignInRequested('user1', 'pass1');
        final event2 = SignInRequested('user1', 'pass1');

        // Assert
        expect(event1.name, equals(event2.name));
        expect(event1.password, equals(event2.password));
      });
    });

    group('SignUpRequested', () {
      test('should create SignUpRequested with correct values', () {
        // Arrange
        const String name = 'testuser';
        const String password = 'testpassword';

        // Act
        final event = SignUpRequested(name, password);

        // Assert
        expect(event.name, equals(name));
        expect(event.password, equals(password));
      });

      test('should create equal instances with same values', () {
        // Arrange & Act
        final event1 = SignUpRequested('user1', 'pass1');
        final event2 = SignUpRequested('user1', 'pass1');

        // Assert
        expect(event1.name, equals(event2.name));
        expect(event1.password, equals(event2.password));
      });
    });

    group('SignOutRequested', () {
      test('should create SignOutRequested', () {
        // Act
        final event = SignOutRequested();

        // Assert
        expect(event, isA<SignOutRequested>());
      });
    });

    group('FindMeRequested', () {
      test('should create FindMeRequested', () {
        // Act
        final event = FindMeRequested();

        // Assert
        expect(event, isA<FindMeRequested>());
      });
    });

    group('FoundYouEvent', () {
      test('should create FoundYouEvent', () {
        // Act
        final event = FoundYouEvent();

        // Assert
        expect(event, isA<FoundYouEvent>());
      });
    });

    group('AuthLoadingEvent', () {
      test('should create AuthLoadingEvent', () {
        // Act
        final event = AuthLoadingEvent();

        // Assert
        expect(event, isA<AuthLoadingEvent>());
      });
    });

    group('AuthRegisteredEvent', () {
      test('should create AuthRegisteredEvent', () {
        // Act
        final event = AuthRegisteredEvent();

        // Assert
        expect(event, isA<AuthRegisteredEvent>());
      });
    });

    group('AuthSuccessEvent', () {
      test('should create AuthSuccessEvent with correct user', () {
        // Arrange
        const user = UserAuth(id: '1', name: 'testuser', token: 'token123');

        // Act
        final event = AuthSuccessEvent(user);

        // Assert
        expect(event.user, equals(user));
      });

      test('should create equal instances with same values', () {
        // Arrange & Act
        const user = UserAuth(id: '1', name: 'testuser', token: 'token123');
        final event1 = AuthSuccessEvent(user);
        final event2 = AuthSuccessEvent(user);

        // Assert
        expect(event1.user, equals(event2.user));
      });
    });

    group('AuthFailureEvent', () {
      test('should create AuthFailureEvent with correct message', () {
        // Arrange
        const String message = 'Authentication failed';

        // Act
        final event = AuthFailureEvent(message);

        // Assert
        expect(event.message, equals(message));
      });

      test('should create equal instances with same values', () {
        // Arrange & Act
        final event1 = AuthFailureEvent('Error 1');
        final event2 = AuthFailureEvent('Error 1');

        // Assert
        expect(event1.message, equals(event2.message));
      });

      test('should handle empty message', () {
        // Arrange
        const String message = '';

        // Act
        final event = AuthFailureEvent(message);

        // Assert
        expect(event.message, equals(message));
      });
    });
  });
} 