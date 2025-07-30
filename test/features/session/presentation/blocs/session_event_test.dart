import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/session/presentation/blocs/session_event.dart';

void main() {
  group('SessionEvent', () {
    test('LoadSession should be instance of LoadSession', () {
      // Arrange & Act
      final LoadSession loadSessionEvent = LoadSession();

      // Assert
      expect(loadSessionEvent, isA<LoadSession>());
    });

    test('CreateSession should have correct properties', () {
      // Arrange
      const double latitude = 40.7128;
      const double longitude = -74.0060;
      const String name = 'Test Session';
      const bool open = true;

      // Act
      final CreateSession createSessionEvent = CreateSession(latitude, longitude, name, open);

      // Assert
      expect(createSessionEvent.latitude, equals(latitude));
      expect(createSessionEvent.longitude, equals(longitude));
      expect(createSessionEvent.name, equals(name));
      expect(createSessionEvent.open, equals(open));
    });

    test('CloseSession should have correct id', () {
      // Arrange
      const int id = 123;

      // Act
      final CloseSession closeSessionEvent = CloseSession(id);

      // Assert
      expect(closeSessionEvent.id, equals(id));
    });

    test('JoinSession should have correct sessionId', () {
      // Arrange
      const int sessionId = 456;

      // Act
      final JoinSession joinSessionEvent = JoinSession(sessionId);

      // Assert
      expect(joinSessionEvent.sessionId, equals(sessionId));
    });

    test('RespondToRequest should have correct properties', () {
      // Arrange
      const int participantId = 789;
      const int sessionId = 456;
      const bool accept = true;

      // Act
      final RespondToRequest respondToRequestEvent = RespondToRequest(participantId, sessionId, accept);

      // Assert
      expect(respondToRequestEvent.participantId, equals(participantId));
      expect(respondToRequestEvent.sessionId, equals(sessionId));
      expect(respondToRequestEvent.accept, equals(accept));
    });

    test('RespondToRequest should work with accept = false', () {
      // Arrange
      const int participantId = 789;
      const int sessionId = 456;
      const bool accept = false;

      // Act
      final RespondToRequest respondToRequestEvent = RespondToRequest(participantId, sessionId, accept);

      // Assert
      expect(respondToRequestEvent.participantId, equals(participantId));
      expect(respondToRequestEvent.sessionId, equals(sessionId));
      expect(respondToRequestEvent.accept, equals(accept));
    });

    test('LeaveSession should be instance of LeaveSession', () {
      // Arrange & Act
      final LeaveSession leaveSessionEvent = LeaveSession();

      // Assert
      expect(leaveSessionEvent, isA<LeaveSession>());
    });
  });
}
