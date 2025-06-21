import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/core/domain/models/profile.dart';
import 'package:dio/dio.dart';

class MapRemoteDataSource {
  final ApiClient apiClient;
  MapRemoteDataSource(this.apiClient);

  Future<List<Profile>> fetchNearbyProfiles(final double latitude,final double longitude, final double radiusKm) async {
    final Response<dynamic> response = await apiClient.get(
      '/presence/nearby',
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'radiusKm': radiusKm.toString(),
      },
    );

    return ((response.data as Map<String, dynamic>)['profiles'] as List<dynamic>)
        .map((final dynamic json) => Profile.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}