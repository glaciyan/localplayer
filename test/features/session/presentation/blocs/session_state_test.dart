import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/session/presentation/blocs/session_state.dart';
import 'package:localplayer/features/session/domain/models/session_model.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('SessionState', () {
    test('SessionInitial should be instance of SessionInitial', () {
      // Arrange & Act
      final SessionInitial state = SessionInitial();

      // Assert
      expect(state, isA<SessionInitial>());
    });

    test('SessionLoading should be instance of SessionLoading', () {
      // Arrange & Act
      final SessionLoading state = SessionLoading();

      // Assert
      expect(state, isA<SessionLoading>());
    });

    test('SessionActive should have correct session', () {
      // Arrange
      final SessionModel session = SessionModel(
        id: 1,
        createdAt: DateTime.now(),
        updateAt: DateTime.now(),
        status: 'active',
        name: 'Test Session',
        position: const LatLng(40.7128, -74.0060),
      );

      // Act
      final SessionActive state = SessionActive(session);

      // Assert
      expect(state.session, equals(session));
    });

    test('SessionActive should work with null position', () {
      // Arrange
      final SessionModel session = SessionModel(
        id: 1,
        createdAt: DateTime.now(),
        updateAt: DateTime.now(),
        status: 'active',
        name: 'Test Session',
        position: null,
      );

      // Act
      final SessionActive state = SessionActive(session);

      // Assert
      expect(state.session, equals(session));
      expect(state.session.position, isNull);
    });

    test('SessionInactive should be instance of SessionInactive', () {
      // Arrange & Act
      final SessionInactive state = SessionInactive();

      // Assert
      expect(state, isA<SessionInactive>());
    });

    test('SessionError should have correct message', () {
      // Arrange
      const String message = 'Test error message';

      // Act
      final SessionError state = SessionError(message);

      // Assert
      expect(state.message, equals(message));
    });
  });
}
