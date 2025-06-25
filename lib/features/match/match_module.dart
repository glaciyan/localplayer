// features/match/match_module.dart
import 'package:flutter/widgets.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/features/match/domain/controllers/match_controller.dart';
import 'package:localplayer/features/match/domain/interfaces/match_controller_interface.dart';
import 'package:localplayer/features/match/presentation/blocs/match_bloc.dart';
import 'package:localplayer/features/match/data/repositories/match_repository_impl.dart';
import 'package:localplayer/features/match/data/datasources/match_remote_data_source.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/features/match/data/match_repository_interface.dart';
import 'package:localplayer/core/services/spotify/data/services/config_service.dart';

class MatchModule {
  static MatchBloc provideBloc({
    required final ISpotifyRepository spotifyRepository,
    required final IMatchRepository matchRepository,
  }) => MatchBloc(
    repository: matchRepository,
    spotifyRepository: spotifyRepository,
  );


  static IMatchController provideController(final BuildContext context, final MatchBloc bloc) => MatchController(
      context,
      bloc.add,
    );

  static IMatchRepository provideRepository(final ISpotifyRepository spotifyRepository, final ConfigService config) => MatchRepository(
    spotifyRepository,
    MatchRemoteDataSource(ApiClient(baseUrl: config.apiBaseUrl))
  );
}


