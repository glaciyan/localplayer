import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';

abstract class IMatchController {
  void like(ProfileWithSpotify profile);
  void dislike(ProfileWithSpotify profile);
  void loadProfiles();
}