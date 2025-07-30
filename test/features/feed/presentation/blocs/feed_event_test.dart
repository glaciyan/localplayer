import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_event.dart';

void main() {
  group('FeedEvent', () {
    test('LoadFeed should be instance of LoadFeed', () {
      // Arrange & Act
      final event = LoadFeed();

      // Assert
      expect(event, isA<LoadFeed>());
    });

    test('RefreshFeed should be instance of RefreshFeed', () {
      // Arrange & Act
      final event = RefreshFeed();

      // Assert
      expect(event, isA<RefreshFeed>());
    });

    test('AcceptSession should have correct properties', () {
      // Arrange
      const sessionId = 1;
      const userId = 2;

      // Act
      final event = AcceptSession(sessionId, userId);

      // Assert
      expect(event.sessionId, equals(sessionId));
      expect(event.userId, equals(userId));
    });

    test('RejectSession should have correct properties', () {
      // Arrange
      const sessionId = 1;
      const userId = 2;

      // Act
      final event = RejectSession(sessionId, userId);

      // Assert
      expect(event.sessionId, equals(sessionId));
      expect(event.userId, equals(userId));
    });

    test('PingUser should have correct properties', () {
      // Arrange
      const userId = 1;

      // Act
      final event = PingUser(userId);

      // Assert
      expect(event.userId, equals(userId));
    });

    test('RespondToRequest should have correct properties', () {
      // Arrange
      const participantId = 1;
      const sessionId = 2;
      const accept = true;

      // Act
      final event = RespondToRequest(participantId, sessionId, accept);

      // Assert
      expect(event.participantId, equals(participantId));
      expect(event.sessionId, equals(sessionId));
      expect(event.accept, equals(accept));
    });

    test('AcceptSession should have correct sessionId and userId', () {
      // Arrange & Act
      final event = AcceptSession(1, 2);

      // Assert
      expect(event.sessionId, equals(1));
      expect(event.userId, equals(2));
    });
  });
} 