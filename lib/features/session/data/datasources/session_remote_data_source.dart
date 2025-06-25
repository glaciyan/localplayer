import 'package:dio/dio.dart';
import 'package:localplayer/core/network/api_client.dart';

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
}
