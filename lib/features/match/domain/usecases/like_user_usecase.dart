import 'package:localplayer/core/entities/user_profile.dart';

import '../repositories/match_repository.dart';

class LikeUserUseCase {
  final MatchRepository repository;

  LikeUserUseCase(this.repository);

  Future<void> call(final UserProfile user) => repository.like(user);
}
