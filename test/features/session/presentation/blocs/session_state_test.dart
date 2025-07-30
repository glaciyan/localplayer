import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/session/presentation/blocs/session_state.dart';
import 'package:localplayer/features/session/domain/models/session_model.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('SessionState', () {
    test('SessionInitial should be instance of SessionInitial', () {
      // Arrange & Act
      final state = SessionInitial();

      // Assert
      expect(state, isA<SessionInitial>());
    });

    test('SessionLoading should be instance of SessionLoading', () {
      // Arrange & Act
      final state = SessionLoading();

      // Assert
      expect(state, isA<SessionLoading>());
    });

    test('SessionActive should have correct session', () {
      // Arrange
      final session = SessionModel(
        id: 1,
        createdAt: DateTime.now(),
        updateAt: DateTime.now(),
        status: 'active',
        name: 'Test Session',
        position: const LatLng(40.7128, -74.0060),
      );

      // Act
      final state = SessionActive(session);

      // Assert
      expect(state.session, equals(session));
    });

    test('SessionActive should work with null position', () {
      // Arrange
      final session = SessionModel(
        id: 1,
        createdAt: DateTime.now(),
        updateAt: DateTime.now(),
        status: 'active',
        name: 'Test Session',
        position: null,
      );

      // Act
      final state = SessionActive(session);

      // Assert
      expect(state.session, equals(session));
      expect(state.session.position, isNull);
    });

    test('SessionInactive should be instance of SessionInactive', () {
      // Arrange & Act
      final state = SessionInactive();

      // Assert
      expect(state, isA<SessionInactive>());
    });

    test('SessionError should have correct message', () {
      // Arrange
      const message = 'Test error message';

      // Act
      final state = SessionError(message);

      // Assert
      expect(state.message, equals(message));
    });
  });
}
