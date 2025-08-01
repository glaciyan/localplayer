import 'package:localplayer/features/session/domain/models/session_model.dart';

abstract class ISessionRepository {
  Future<SessionModel?> getCurrentSession();
  Future<SessionModel> createSession(
    final double latitude,
    final double longitude,
    final String name,
    final bool open,
  );
  Future<void> closeSession(final int id);
  Future<dynamic> joinSession(final int sessionId);
  Future<void> respondToRequest(
    final int participantId,
    final int sessionId,
    final bool accept,
  );
  Future<void> leaveSession();
}
