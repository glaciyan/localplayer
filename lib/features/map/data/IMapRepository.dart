import 'package:localplayer/core/domain/models/profile.dart';

abstract class IMapRepository {
  Future<List<Profile>> getNearbyProfiles({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  });
}