import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import '../repositories/match_repository.dart';

class LikeUserUseCase {
  final MatchRepository repository;

  LikeUserUseCase(this.repository);

  Future<void> call(UserProfile user) => repository.like(user);
}
