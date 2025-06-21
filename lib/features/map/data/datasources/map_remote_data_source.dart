import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/core/domain/models/profile.dart';

class MapRemoteDataSource {
  final ApiClient apiClient;
  MapRemoteDataSource(this.apiClient);

  Future<List<Profile>> fetchNearbyProfiles(double latitude, double longitude, double radiusKm) async {
    final response = await apiClient.get(
      '/presence/nearby',
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'radiusKm': radiusKm.toString(),
      },
    );

    return (response.data['profiles'] as List)
        .map((json) => Profile.fromJson(json))
        .toList();
  }
}