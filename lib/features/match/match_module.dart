// features/match/match_module.dart
import 'package:flutter/widgets.dart';
import 'package:localplayer/features/match/data/repositories/fake_match_repository.dart';
import 'package:localplayer/features/match/domain/controllers/match_controller.dart';
import 'package:localplayer/features/match/domain/controllers/match_controller_interface.dart';
import 'package:localplayer/features/match/presentation/blocs/match_block.dart';
import 'package:localplayer/spotify/domain/repositories/spotify_repository.dart';

import 'domain/repositories/match_repository.dart';
import 'domain/usecases/like_user_usecase.dart';
import 'domain/usecases/dislike_user_usecase.dart';

class MatchModule {
  static MatchBloc provideBloc({
    required ISpotifyRepository spotifyRepository,
  }) {
    final MatchRepository repo = FakeMatchRepository();
    final like = LikeUserUseCase(repo);
    final dislike = DislikeUserUseCase(repo);
    return MatchBloc(
      likeUseCase: like,
      dislikeUseCase: dislike,
      repository: repo,
      spotifyRepository: spotifyRepository,
    );
  }

  static IMatchController provideController(BuildContext context, MatchBloc bloc) {
    return MatchController(
      context,
      (event) => bloc.add(event),
    );
  }
}


