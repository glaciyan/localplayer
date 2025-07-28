abstract class IPresenceService {
  Future<void> updateLocation({
    required final double latitude,
    required final double longitude,
    required final double fakingRadiusMeters,
  });
} 