import 'package:localplayer/core/entities/profile_with_spotify.dart';

abstract class IMapRepository {
  Future<List<ProfileWithSpotify>> fetchProfiles(final double latitude, final double longitude, final double radiusKm);
}
