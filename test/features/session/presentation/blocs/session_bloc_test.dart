import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/session/presentation/blocs/session_event.dart';
import 'package:localplayer/features/session/presentation/blocs/session_state.dart';
import 'package:localplayer/features/session/domain/models/session_model.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('SessionBloc', () {
    test('SessionEvent instances should be created correctly', () {
      // Test LoadSession
      final loadSessionEvent = LoadSession();
      expect(loadSessionEvent, isA<LoadSession>());

      // Test CreateSession
      const latitude = 40.7128;
      const longitude = -74.0060;
      const name = 'Test Session';
      const open = true;
      final createSessionEvent = CreateSession(latitude, longitude, name, open);
      expect(createSessionEvent, isA<CreateSession>());
      expect(createSessionEvent.latitude, equals(latitude));
      expect(createSessionEvent.longitude, equals(longitude));
      expect(createSessionEvent.name, equals(name));
      expect(createSessionEvent.open, equals(open));

      // Test CloseSession
      const id = 123;
      final closeSessionEvent = CloseSession(id);
      expect(closeSessionEvent, isA<CloseSession>());
      expect(closeSessionEvent.id, equals(id));

      // Test JoinSession
      const sessionId = 456;
      final joinSessionEvent = JoinSession(sessionId);
      expect(joinSessionEvent, isA<JoinSession>());
      expect(joinSessionEvent.sessionId, equals(sessionId));

      // Test RespondToRequest
      const participantId = 789;
      const requestSessionId = 456;
      const accept = true;
      final respondToRequestEvent = RespondToRequest(participantId, requestSessionId, accept);
      expect(respondToRequestEvent, isA<RespondToRequest>());
      expect(respondToRequestEvent.participantId, equals(participantId));
      expect(respondToRequestEvent.sessionId, equals(requestSessionId));
      expect(respondToRequestEvent.accept, equals(accept));

      // Test LeaveSession
      final leaveSessionEvent = LeaveSession();
      expect(leaveSessionEvent, isA<LeaveSession>());
    });

    test('SessionState instances should be created correctly', () {
      // Test SessionInitial
      final sessionInitialState = SessionInitial();
      expect(sessionInitialState, isA<SessionInitial>());

      // Test SessionLoading
      final sessionLoadingState = SessionLoading();
      expect(sessionLoadingState, isA<SessionLoading>());

      // Test SessionActive
      final session = SessionModel(
        id: 1,
        createdAt: DateTime.now(),
        updateAt: DateTime.now(),
        status: 'active',
        name: 'Test Session',
        position: const LatLng(40.7128, -74.0060),
      );
      final sessionActiveState = SessionActive(session);
      expect(sessionActiveState, isA<SessionActive>());
      expect(sessionActiveState.session, equals(session));

      // Test SessionInactive
      final sessionInactiveState = SessionInactive();
      expect(sessionInactiveState, isA<SessionInactive>());

      // Test SessionError
      const errorMessage = 'Test error message';
      final sessionErrorState = SessionError(errorMessage);
      expect(sessionErrorState, isA<SessionError>());
      expect(sessionErrorState.message, equals(errorMessage));
    });

    test('SessionModel should be created correctly', () {
      // Arrange
      const id = 1;
      final createdAt = DateTime.now();
      final updateAt = DateTime.now();
      const status = 'active';
      const name = 'Test Session';
      const position = LatLng(40.7128, -74.0060);

      // Act
      final session = SessionModel(
        id: id,
        createdAt: createdAt,
        updateAt: updateAt,
        status: status,
        name: name,
        position: position,
      );

      // Assert
      expect(session.id, equals(id));
      expect(session.createdAt, equals(createdAt));
      expect(session.updateAt, equals(updateAt));
      expect(session.status, equals(status));
      expect(session.name, equals(name));
      expect(session.position, equals(position));
    });

    test('SessionModel should work with null position', () {
      // Arrange
      const id = 1;
      final createdAt = DateTime.now();
      final updateAt = DateTime.now();
      const status = 'active';
      const name = 'Test Session';

      // Act
      final session = SessionModel(
        id: id,
        createdAt: createdAt,
        updateAt: updateAt,
        status: status,
        name: name,
        position: null,
      );

      // Assert
      expect(session.id, equals(id));
      expect(session.createdAt, equals(createdAt));
      expect(session.updateAt, equals(updateAt));
      expect(session.status, equals(status));
      expect(session.name, equals(name));
      expect(session.position, isNull);
    });
  });
}
