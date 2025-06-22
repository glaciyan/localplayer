import 'package:localplayer/core/entities/profile_with_spotify.dart';

abstract class IMapRepository {
  Future<List<ProfileWithSpotify>> fetchProfiles();
}
