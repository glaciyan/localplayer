import 'package:localplayer/features/session/data/session_repository_interface.dart';
import 'package:localplayer/features/session/data/datasources/session_remote_data_source.dart';
import 'package:localplayer/features/session/domain/models/session_model.dart';

class SessionRepository implements ISessionRepository {
  final SessionRemoteDataSource dataSource;

  SessionRepository(this.dataSource);

  @override
  Future<SessionModel?> getCurrentSession() async {
    final Map<String, dynamic>? data = await dataSource.getCurrentSession();
    return data == null ? null : SessionModel.fromJson(data);
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
  Future<Map<String, dynamic>> joinSession(final int sessionId) async {
    final Map<String, dynamic> json = await dataSource.joinSession(sessionId);
    return json;
  }
}
