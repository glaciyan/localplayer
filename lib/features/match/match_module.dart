// features/match/match_module.dart
import 'package:flutter/widgets.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/core/services/spotify/data/services/config_service.dart';
import 'package:localplayer/core/services/spotify/spotify_module.dart';
import 'package:localplayer/features/match/data/repositories/match_repository_impl.dart';
import 'package:localplayer/features/match/domain/controllers/match_controller.dart';
import 'package:localplayer/features/match/domain/controllers/match_controller_interface.dart';
import 'package:localplayer/features/match/domain/repositories/match_repository.dart';
import 'package:localplayer/features/match/domain/usecases/dislike_user_usecase.dart';
import 'package:localplayer/features/match/domain/usecases/like_user_usecase.dart';
import 'package:localplayer/features/match/presentation/blocs/match_bloc.dart';

class MatchModule {
  static MatchBloc provideBloc(final ConfigService config) {
    final MatchRepository repo = MatchRepositoryImpl(
      apiClient: ApiClient(baseUrl: config.apiBaseUrl),
      spotifyRepository: SpotifyModule.provideRepository(config),
    );

    final like = LikeUserUseCase(repo);
    final dislike = DislikeUserUseCase(repo);

    return MatchBloc(
      likeUseCase: like,
      dislikeUseCase: dislike,
      repository: repo,
      spotifyRepository: SpotifyModule.provideRepository(config),
    );
  }

  static IMatchController provideController(
    final BuildContext context,
    final MatchBloc bloc,
  ) =>
      MatchController(context, bloc.add);
}

