import 'package:localplayer/features/session/domain/models/session_model.dart';

abstract class SessionState {}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class SessionActive extends SessionState {
  final SessionModel session;

  SessionActive(this.session);
}

class SessionInactive extends SessionState {}

class SessionError extends SessionState {
  final String message;

  SessionError(this.message);
}
