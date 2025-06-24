// features/match/match_module.dart
import 'package:flutter/widgets.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/features/match/data/repositories/fake_match_repository.dart';
import 'package:localplayer/features/match/domain/controllers/match_controller.dart';
import 'package:localplayer/features/match/domain/controllers/match_controller_interface.dart';
import 'package:localplayer/features/match/domain/repositories/match_repository.dart';
import 'package:localplayer/features/match/domain/usecases/dislike_user_usecase.dart';
import 'package:localplayer/features/match/domain/usecases/like_user_usecase.dart';
import 'package:localplayer/features/match/presentation/blocs/match_bloc.dart';

class MatchModule {
  static MatchBloc provideBloc({
    required final ISpotifyRepository spotifyRepository,
  }) {
    final MatchRepository repo = FakeMatchRepository();
    final LikeUserUseCase like = LikeUserUseCase(repo);
    final DislikeUserUseCase dislike = DislikeUserUseCase(repo);
    return MatchBloc(
      likeUseCase: like,
      dislikeUseCase: dislike,
      repository: repo,
      spotifyRepository: spotifyRepository,
    );
  }

  static IMatchController provideController(final BuildContext context, final MatchBloc bloc) => MatchController(
      context,
      bloc.add,
    );
}


