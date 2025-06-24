import 'package:localplayer/core/entities/user_profile.dart';

abstract class MatchRepository {
  Future<List<UserProfile>> fetchProfiles();
  Future<void> like(final UserProfile user);
  Future<void> dislike(final UserProfile user);
}
