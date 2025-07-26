import 'package:localplayer/core/entities/profile_with_spotify.dart';

abstract class IProfileRepository {
  Future<ProfileWithSpotify> fetchCurrentUserEnrichedProfile();
  Future<ProfileWithSpotify> updateUserProfile(final ProfileWithSpotify profile);
  Future<void> signOut();
}
