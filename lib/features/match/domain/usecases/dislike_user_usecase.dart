import 'package:localplayer/features/match/domain/entities/UserProfile.dart';
import '../repositories/match_repository.dart';

class DislikeUserUseCase {
  final MatchRepository repository;

  DislikeUserUseCase(this.repository);

  Future<void> call(UserProfile user) => repository.dislike(user);
}
