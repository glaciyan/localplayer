import 'package:localplayer/core/entities/profile_with_spotify.dart';

abstract class IMatchController {
  void like(final ProfileWithSpotify profile);
  void dislike(final ProfileWithSpotify profile);
  void loadProfiles();
}