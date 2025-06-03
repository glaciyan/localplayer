import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import '../repositories/match_repository.dart';

class DislikeUserUseCase {
  final MatchRepository repository;

  DislikeUserUseCase(this.repository);

  Future<void> call(UserProfile user) => repository.dislike(user);
}
