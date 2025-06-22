// lib/core/map_module.dart

import 'package:flutter/material.dart';
import 'package:localplayer/features/map/domain/controllers/map_controller.dart';
import 'package:localplayer/features/map/domain/controllers/map_controller_interface.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:localplayer/features/map/data/datasources/map_remote_data_source.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/core/domain/models/profile.dart';
import 'package:localplayer/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/features/map/domain/repositories/i_map_repository.dart';

class MapModule {
  static MapBloc provideBloc({
    required final IMapRepository mapRepository,
    required final ISpotifyRepository spotifyRepository,
  }) => MapBloc(
      mapRepository: mapRepository,
      spotifyRepository: spotifyRepository,
    );

  static IMapController provideController(
    BuildContext context,
    MapBloc bloc,
  ) {
    return MapController(context, bloc.add);
  }
}
