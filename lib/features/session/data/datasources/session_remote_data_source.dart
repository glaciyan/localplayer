import 'package:dio/dio.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/main.dart';

class SessionRemoteDataSource {
  final ApiClient apiClient;

  SessionRemoteDataSource(this.apiClient);

  Future<Map<String, dynamic>> createSession(
    final double latitude,
    final double longitude,
    final String name,
    final bool open,
  ) async {
    final Response<dynamic> response = await apiClient.post(
      '/session',
      data: <String, dynamic>{
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'name': name,
        'open': open,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> getCurrentSession() async {
    try {
      final Response<dynamic> response = await apiClient.get('/session');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  Future<void> closeSession(final int id) async {
    await apiClient.post('/session/close/$id');
  }

  Future<Map<String, dynamic>> joinSession(final int sessionId) async {
    final Response<dynamic> response = await apiClient.post('/session/$sessionId/join');
    log.i('Joining session: $sessionId');
    log.i('Response: ${response.data}');
    return response.data as Map<String, dynamic>;
  }

  Future<void> respondToRequest(
    final int participantId,
    final int sessionId,
    final bool accept,
  ) async {
    final Map<String, dynamic> body = <String, dynamic>{
      'participantId': participantId,
      'sessionId': sessionId,
      'accept': accept,
    };
    
    await apiClient.post('/session/requests/respond', data: body);
  }

  Future<void> leaveSession() async {
    await apiClient.post('/session/leave');
  }
}
