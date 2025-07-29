import 'package:localplayer/features/session/data/session_repository_interface.dart';
import 'package:localplayer/features/session/data/datasources/session_remote_data_source.dart';
import 'package:localplayer/features/session/domain/models/session_model.dart';
import 'package:localplayer/main.dart';

class SessionRepository implements ISessionRepository {
  final SessionRemoteDataSource dataSource;

  SessionRepository(this.dataSource);

  @override
  Future<SessionModel?> getCurrentSession() async {
    final dynamic data = await dataSource.getCurrentSession();
    log.i('getCurrentSession data type: ${data.runtimeType}');
    log.i('getCurrentSession data: $data');
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      return SessionModel.fromJson(data);
    } else {
      log.e('getCurrentSession received non-Map data: $data');
      return null;
    }
  }

  @override
  Future<SessionModel> createSession(
    final double latitude,
    final double longitude,
    final String name,
    final bool open,
  ) async {
    final Map<String, dynamic> json = await dataSource.createSession(
      latitude,
      longitude,
      name,
      open,
    );
    return SessionModel.fromJson(json);
  }

  @override
  Future<void> closeSession(final int id) => dataSource.closeSession(id);

  @override
  Future<dynamic> joinSession(final int sessionId) async {
    final dynamic result = await dataSource.joinSession(sessionId);
    log.i('Repository: $result');
    return result;
  }

  @override
  Future<void> respondToRequest(
    final int participantId,
    final int sessionId,
    final bool accept,
  ) async {
    log.i('Repository: $participantId, $sessionId, $accept');
    await dataSource.respondToRequest(participantId, sessionId, accept);
    log.i('Repository: done');
  }

  @override
  Future<void> leaveSession() => dataSource.leaveSession();
}
