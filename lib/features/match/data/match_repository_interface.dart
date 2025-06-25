import 'package:localplayer/core/entities/profile_with_spotify.dart';

abstract class IMatchRepository {
  Future<List<ProfileWithSpotify>> fetchProfilesWithSpotify(final double latitude, final double longitude, final double radiusKm);
  Future<Map<String, dynamic>> like(final String profileId);
  Future<Map<String, dynamic>> dislike(final String profileId);
}