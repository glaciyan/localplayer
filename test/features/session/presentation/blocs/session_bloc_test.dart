import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/session/presentation/blocs/session_event.dart';
import 'package:localplayer/features/session/presentation/blocs/session_state.dart';
import 'package:localplayer/features/session/domain/models/session_model.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('SessionBloc', () {
    test('SessionEvent instances should be created correctly', () {
      // Test LoadSession
      final LoadSession loadSessionEvent = LoadSession();
      expect(loadSessionEvent, isA<LoadSession>());

      // Test CreateSession
      const double latitude = 40.7128;
      const double longitude = -74.0060;
      const String name = 'Test Session';
      const bool open = true;
      final CreateSession createSessionEvent = CreateSession(latitude, longitude, name, open);
      expect(createSessionEvent, isA<CreateSession>());
      expect(createSessionEvent.latitude, equals(latitude));
      expect(createSessionEvent.longitude, equals(longitude));
      expect(createSessionEvent.name, equals(name));
      expect(createSessionEvent.open, equals(open));

      // Test CloseSession
      const int id = 123;
      final CloseSession closeSessionEvent = CloseSession(id);
      expect(closeSessionEvent, isA<CloseSession>());
      expect(closeSessionEvent.id, equals(id));

      // Test JoinSession
      const int sessionId = 456;
      final JoinSession joinSessionEvent = JoinSession(sessionId);
      expect(joinSessionEvent, isA<JoinSession>());
      expect(joinSessionEvent.sessionId, equals(sessionId));

      // Test RespondToRequest
      const int participantId = 789;
      const int requestSessionId = 456;
      const bool accept = true;
      final RespondToRequest respondToRequestEvent = RespondToRequest(participantId, requestSessionId, accept);
      expect(respondToRequestEvent, isA<RespondToRequest>());
      expect(respondToRequestEvent.participantId, equals(participantId));
      expect(respondToRequestEvent.sessionId, equals(requestSessionId));
      expect(respondToRequestEvent.accept, equals(accept));

      // Test LeaveSession
      final LeaveSession leaveSessionEvent = LeaveSession();
      expect(leaveSessionEvent, isA<LeaveSession>());
    });

    test('SessionState instances should be created correctly', () {
      // Test SessionInitial
      final SessionInitial sessionInitialState = SessionInitial();
      expect(sessionInitialState, isA<SessionInitial>());

      // Test SessionLoading
      final SessionLoading sessionLoadingState = SessionLoading();
      expect(sessionLoadingState, isA<SessionLoading>());

      // Test SessionActive
      final SessionModel session = SessionModel(
        id: 1,
        createdAt: DateTime.now(),
        updateAt: DateTime.now(),
        status: 'active',
        name: 'Test Session',
        position: const LatLng(40.7128, -74.0060),
      );
      final SessionActive sessionActiveState = SessionActive(session);
      expect(sessionActiveState, isA<SessionActive>());
      expect(sessionActiveState.session, equals(session));

      // Test SessionInactive
      final SessionInactive sessionInactiveState = SessionInactive();
      expect(sessionInactiveState, isA<SessionInactive>());

      // Test SessionError
      const String errorMessage = 'Test error message';
      final SessionError sessionErrorState = SessionError(errorMessage);
      expect(sessionErrorState, isA<SessionError>());
      expect(sessionErrorState.message, equals(errorMessage));
    });

    test('SessionModel should be created correctly', () {
      // Arrange
      const int id = 1;
      final DateTime createdAt = DateTime.now();
      final DateTime updateAt = DateTime.now();
      const String status = 'active';
      const String name = 'Test Session';
      const LatLng position = LatLng(40.7128, -74.0060);

      // Act
      final SessionModel session = SessionModel(
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
      const int id = 1;
      final DateTime createdAt = DateTime.now();
      final DateTime updateAt = DateTime.now();
      const String status = 'active';
      const String name = 'Test Session';

      // Act
      final SessionModel session = SessionModel(
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
