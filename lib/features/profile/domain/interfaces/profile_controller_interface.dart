import 'package:localplayer/core/entities/profile_with_spotify.dart';

abstract class IProfileController {
  void updateProfile(final ProfileWithSpotify profile);
  void getCurrentUserProfile();
  void signOut();
}