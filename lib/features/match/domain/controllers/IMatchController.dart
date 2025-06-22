import 'package:localplayer/features/match/domain/entities/user_profile.dart';

abstract class IMatchController {
  void like(final UserProfile profile);
  void dislike(final UserProfile profile);
  void loadProfiles();
}