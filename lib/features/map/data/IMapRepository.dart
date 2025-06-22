import 'package:localplayer/core/domain/models/profile.dart';

abstract class IMapRepository {
  Future<List<Profile>> getNearbyProfiles({
    required final double latitude,
    required final double longitude,
    final double radiusKm = 10.0,
  });
}