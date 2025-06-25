import 'package:localplayer/core/network/api_client.dart';
import 'package:dio/dio.dart';

class MatchRemoteDataSource {
  final ApiClient apiClient;
  
  MatchRemoteDataSource(this.apiClient);

  Future<Map<String, dynamic>> fetchProfiles(final double latitude, final double longitude, final double radiusKm) async {
    final Response<dynamic> response = await apiClient.get(
      '/presence/nearby',
      queryParameters: <String, String> {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'radiusKm': radiusKm.toString(),
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> like(final String profileId) async {
    final Response<dynamic> response = await apiClient.post('/swipe/good/$profileId');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> dislike(final String profileId) async {
    final Response<dynamic> response = await apiClient.post('/swipe/bad/$profileId');
    return response.data as Map<String, dynamic>;
  }
}