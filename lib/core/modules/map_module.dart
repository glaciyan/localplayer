// lib/core/map_module.dart

import 'package:flutter/material.dart';
import 'package:localplayer/core/controllers/map_controller.dart';
import 'package:localplayer/core/domain/interfaces/map_controller_interface.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';

class MapModule {
  static IMapController provideController(BuildContext context, MapBloc bloc) {
    return MapController(
      context,
      (event) => bloc.add(event),
    );
  }
}