import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:dio/dio.dart';

class MapRemoteDataSource {
  final ApiClient apiClient;
  
  MapRemoteDataSource(this.apiClient);

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

  Future<UserProfile> fetchMe() async {
    final Response<dynamic> response = await apiClient.get('/profile/me');
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  }
}