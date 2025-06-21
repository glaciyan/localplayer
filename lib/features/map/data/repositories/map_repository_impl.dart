// lib/features/map/data/repositories/map_repository.dart
import 'package:localplayer/core/domain/models/profile.dart';
import 'package:localplayer/features/map/data/IMapRepository.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:dio/dio.dart';


class MapRepository implements IMapRepository {
  final ApiClient apiClient;
  
  MapRepository(this.apiClient);
  
  @override
  Future<List<Profile>> getNearbyProfiles({
    required final double latitude,
    required final double longitude,
    final double radiusKm = 10.0,
  }) async {
    final Response<dynamic> response = await apiClient.get(
      '/presence/nearby',
      queryParameters: <String, String> {
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