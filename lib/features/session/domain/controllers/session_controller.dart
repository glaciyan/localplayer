import 'package:flutter/material.dart';
import 'package:localplayer/features/session/domain/interfaces/session_controller_interface.dart';
import 'package:localplayer/features/session/presentation/blocs/session_event.dart';

class SessionController implements ISessionController {
  final BuildContext context;
  final Function(SessionEvent) addEvent;

  SessionController(this.context, this.addEvent);

  @override
  void loadSession() => addEvent(LoadSession());

  @override
  void createSession(
    final double latitude,
    final double longitude,
    final String name,
    final bool open,
  ) => addEvent(CreateSession(latitude, longitude, name, open));

  @override
  void closeSession(final int id) => addEvent(CloseSession(id));

  @override
  void joinSession(final int sessionId) => addEvent(JoinSession(sessionId));

  @override
  void respondToRequest(
    final int participantId,
    final int sessionId,
    final bool accept,
  ) => addEvent(RespondToRequest(participantId, sessionId, accept));

  @override
  void leaveSession() => addEvent(LeaveSession());
}
