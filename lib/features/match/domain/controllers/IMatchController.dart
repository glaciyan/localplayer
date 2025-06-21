import 'package:localplayer/features/match/domain/entities/user_profile.dart';

abstract class IMatchController {
  void like(UserProfile profile);
  void dislike(UserProfile profile);
  void loadProfiles();
}