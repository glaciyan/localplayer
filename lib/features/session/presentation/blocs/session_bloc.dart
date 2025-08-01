import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/features/session/data/session_repository_interface.dart';
import 'package:localplayer/features/session/domain/models/session_model.dart';
import 'package:localplayer/main.dart';
import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final ISessionRepository repository;

  SessionBloc({required this.repository}) : super(SessionInitial()) {
    on<LoadSession>(_onLoadSession);
    on<CreateSession>(_onCreateSession);
    on<CloseSession>(_onCloseSession);
    on<JoinSession>(_onJoinSession);
    on<RespondToRequest>(_onRespondToRequest);
    on<LeaveSession>(_onLeaveSession);
  }

  Future<void> _onLoadSession(
    final LoadSession event,
    final Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    try {
      final SessionModel? session = await repository.getCurrentSession();
      if (session == null) {
        emit(SessionInactive());
      } else {
        emit(SessionActive(session));
      }
    } catch (e) {
      emit(SessionError('Failed to load session: $e'));
    }
  }

  Future<void> _onCreateSession(
    final CreateSession event,
    final Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    try {
      final SessionModel session = await repository.createSession(
        event.latitude,
        event.longitude,
        event.name,
        event.open,
      );
      emit(SessionActive(session));
    } catch (e) {
      emit(SessionError('Failed to create session: $e'));
    }
  }

  Future<void> _onCloseSession(
    final CloseSession event,
    final Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    try {
      await repository.closeSession(event.id);
      emit(SessionInactive());
    } catch (e) {
      emit(SessionError('Failed to close session: $e'));
    }
  }

  Future<void> _onJoinSession(
    final JoinSession event,
    final Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    try {
      final dynamic result = await repository.joinSession(event.sessionId);
      log.i('✅ Successfully joined session: $result');
      
      // Create SessionModel from the join response
      if (result is Map<String, dynamic>) {
        final SessionModel session = SessionModel.fromJson(result);
        emit(SessionActive(session));
      } else {
        emit(SessionError('Invalid session response format'));
      }
    } catch (e) {
      log.e('❌ Failed to join session: $e');
      emit(SessionError('Failed to join session: $e'));
    }
  }

  Future<void> _onRespondToRequest(
    final RespondToRequest event,
    final Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    try {
      await repository.respondToRequest(
        event.participantId,
        event.sessionId,
        event.accept,
      );
      
      log.i('✅ Successfully responded to request: ${event.accept ? "accepted" : "declined"}');
      
      // Reload current session after responding
      final SessionModel? session = await repository.getCurrentSession();
      if (session == null) {
        emit(SessionInactive());
      } else {
        emit(SessionActive(session));
      }
    } catch (e) {
      log.e('❌ Failed to respond to request: $e');
      emit(SessionError('Failed to respond to request: $e'));
    }
  }

  Future<void> _onLeaveSession(
    final LeaveSession event,
    final Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    try {
      await repository.leaveSession();
      log.i('✅ Successfully left session');
      emit(SessionInactive());
    } catch (e) {
      log.e('❌ Failed to leave session: $e');
      emit(SessionError('Failed to leave session: $e'));
    }
  }
}