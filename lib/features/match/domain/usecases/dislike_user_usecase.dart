import 'package:localplayer/core/entities/user_profile.dart';
import '../repositories/match_repository.dart';

class DislikeUserUseCase {
  final MatchRepository repository;

  DislikeUserUseCase(this.repository);

  Future<void> call(final UserProfile user) => repository.dislike(user);
}
