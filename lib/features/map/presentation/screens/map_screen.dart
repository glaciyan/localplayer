import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';
import 'package:localplayer/features/map/data/map_repository_interface.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart';
import 'package:localplayer/features/map/presentation/widgets/map_widget.dart';



class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(final BuildContext context) => BlocProvider<MapBloc>(
      create: (_) => MapBloc(
        mapRepository: context.read<IMapRepository>(),
        spotifyRepository: context.read<ISpotifyRepository>(),
      )..add(LoadMapProfiles()),
      child: const WithNavBar(
        selectedIndex: 0,
        child: MapWidget(),
      ),
    );
}
