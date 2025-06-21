// lib/core/map_module.dart

import 'package:flutter/material.dart';
import 'package:localplayer/features/map/domain/controllers/map_controller.dart';
import 'package:localplayer/features/map/domain/interfaces/map_controller_interface.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:localplayer/features/map/data/datasources/map_remote_data_source.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/core/domain/models/profile.dart';

class MapModule {
  static MapBloc provideBloc() => MapBloc(
      MapRemoteDataSource(ApiClient()),
      <Profile>[],
    );

  static IMapController provideController(final BuildContext context, final MapBloc bloc) => MapController(
      context,
      bloc.add,
    );
}