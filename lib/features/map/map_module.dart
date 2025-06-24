// lib/core/map_module.dart
import 'package:flutter/material.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/core/services/spotify/data/services/config_service.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/features/map/data/datasources/map_remote_data_source.dart';
import 'package:localplayer/features/map/data/map_repository_interface.dart';
import 'package:localplayer/features/map/data/repositories/map_repository_impl.dart';
import 'package:localplayer/features/map/domain/controllers/map_controller.dart';
import 'package:localplayer/features/map/domain/interfaces/map_controller_interface.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';


class MapModule {
  static MapBloc provideBloc({
    required final IMapRepository mapRepository,
    required final ISpotifyRepository spotifyRepository,
  }) => MapBloc(
      mapRepository: mapRepository,
      spotifyRepository: spotifyRepository,
    );

  static IMapController provideController(
    final BuildContext context,
    final MapBloc bloc,
  ) => MapController(context, bloc.add);

  static IMapRepository provideRepository(final ISpotifyRepository spotifyRepository, final ConfigService config) => MapRepository(
    spotifyRepository,
    MapRemoteDataSource(ApiClient(baseUrl: config.apiBaseUrl))
  );
}
