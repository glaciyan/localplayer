import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/session/presentation/blocs/session_event.dart';

void main() {
  group('SessionEvent', () {
    test('LoadSession should be instance of LoadSession', () {
      // Arrange & Act
      final event = LoadSession();

      // Assert
      expect(event, isA<LoadSession>());
    });

    test('CreateSession should have correct properties', () {
      // Arrange
      const latitude = 40.7128;
      const longitude = -74.0060;
      const name = 'Test Session';
      const open = true;

      // Act
      final event = CreateSession(latitude, longitude, name, open);

      // Assert
      expect(event.latitude, equals(latitude));
      expect(event.longitude, equals(longitude));
      expect(event.name, equals(name));
      expect(event.open, equals(open));
    });

    test('CloseSession should have correct id', () {
      // Arrange
      const id = 123;

      // Act
      final event = CloseSession(id);

      // Assert
      expect(event.id, equals(id));
    });

    test('JoinSession should have correct sessionId', () {
      // Arrange
      const sessionId = 456;

      // Act
      final event = JoinSession(sessionId);

      // Assert
      expect(event.sessionId, equals(sessionId));
    });

    test('RespondToRequest should have correct properties', () {
      // Arrange
      const participantId = 789;
      const sessionId = 456;
      const accept = true;

      // Act
      final event = RespondToRequest(participantId, sessionId, accept);

      // Assert
      expect(event.participantId, equals(participantId));
      expect(event.sessionId, equals(sessionId));
      expect(event.accept, equals(accept));
    });

    test('RespondToRequest should work with accept = false', () {
      // Arrange
      const participantId = 789;
      const sessionId = 456;
      const accept = false;

      // Act
      final event = RespondToRequest(participantId, sessionId, accept);

      // Assert
      expect(event.participantId, equals(participantId));
      expect(event.sessionId, equals(sessionId));
      expect(event.accept, equals(accept));
    });

    test('LeaveSession should be instance of LeaveSession', () {
      // Arrange & Act
      final event = LeaveSession();

      // Assert
      expect(event, isA<LeaveSession>());
    });
  });
}
