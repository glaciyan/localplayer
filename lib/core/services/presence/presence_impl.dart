import 'package:localplayer/core/network/api_client.dart';
import 'presence_interface.dart';

class PresenceService implements IPresenceService {
  final ApiClient apiClient;

  PresenceService(this.apiClient);

  @override
  Future<void> updateLocation({
    required final double latitude,
    required final double longitude,
    required final double fakingRadiusMeters,
  }) async {
    try {
      await apiClient.post('/presence/current', data: <String, String>{ 
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'fakingRadiusMeters': fakingRadiusMeters.toString(),
      });
    } catch (e) {
      throw Exception('Failed to update location: $e');
    }
  }
} 