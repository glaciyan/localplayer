import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/entities/user_profile.dart';

abstract class IMapRepository {
  Future<ProfileWithSpotify> fetchProfileWithSpotify(final UserProfile user);
  Future<List<UserProfile>> fetchProfiles(final double latitude, final double longitude, final double radiusKm);
  Future<List<ProfileWithSpotify>> fetchProfilesWithSpotify(final double latitude, final double longitude, final double radiusKm);
}
