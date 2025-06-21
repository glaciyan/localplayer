// lib/features/map/data/repositories/map_repository.dart
import 'package:localplayer/core/domain/models/profile.dart';
import 'package:localplayer/features/map/data/IMapRepository.dart';
import 'package:localplayer/core/network/api_client.dart';


class MapRepository implements IMapRepository {
  final ApiClient apiClient;
  
  MapRepository(this.apiClient);
  
  @override
  Future<List<Profile>> getNearbyProfiles({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
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