import 'package:localplayer/features/match/domain/entities/user_profile.dart';

abstract class IUserRepository {
  Future<UserProfile> getCurrentUserProfile();
  Future<void> updateUserProfile(final UserProfile profile);

  Future<List<UserProfile>> getDiscoverableUsers();
}
