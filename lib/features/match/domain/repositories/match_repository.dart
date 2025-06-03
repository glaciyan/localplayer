// features/match/domain/repositories/match_repository.dart

import 'package:localplayer/features/match/domain/entities/user_profile.dart';

abstract class MatchRepository {
  Future<List<UserProfile>> fetchProfiles();
  Future<void> like(UserProfile user);
  Future<void> dislike(UserProfile user);
}
