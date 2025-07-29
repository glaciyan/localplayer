import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';
import 'package:localplayer/features/map/data/map_repository_interface.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart';
import 'package:localplayer/features/map/presentation/widgets/map_widget.dart';
import 'package:localplayer/features/session/domain/interfaces/session_controller_interface.dart';



class MapScreen extends StatelessWidget {
  const MapScreen({super.key});
  

  @override
  Widget build(final BuildContext context) => BlocProvider<MapBloc>(
      create: (_) => MapBloc(
        mapRepository: context.read<IMapRepository>(),
        spotifyRepository: context.read<ISpotifyRepository>(),
        sessionController: context.read<ISessionController>(),
      )..add(LoadMapProfiles()),
      child: const WithNavBar(
        selectedIndex: 0,
        child: MapWidget(),
      ),
    );
}
