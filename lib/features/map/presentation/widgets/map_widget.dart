import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/features/map/presentation/widgets/profile_avatar.dart';

import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart';
import 'package:localplayer/features/map/presentation/blocs/map_state.dart';


class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
      
        if (state is MapReady) {
          return Scaffold(
            body: FlutterMap(
              options: MapOptions(
                interactionOptions: InteractionOptions(
                  rotationThreshold: 360,
                ),
                initialCenter: LatLng(51.509364, -0.128928), // London
                initialZoom: 13.0,
                onPositionChanged: (position, hasGesture) {

                  List<Map<String, dynamic>> visiblePeople = state.visiblePeople.where((person) {
                    final pos = person['position'] as LatLng;
                    return position.visibleBounds.contains(pos);
                  }).toList();

                  print('Visible People: $visiblePeople');
                  print('Map moved to: ${position.center.latitude}, ${position.center.longitude}');
                  print('Bounds: ${position.visibleBounds}');
                  context.read<MapBloc>().add(
                    UpdateCameraPosition(position.center.latitude, position.center.longitude, visiblePeople, position.visibleBounds)
                  );
                },
              ),
              children: [
                TileLayer(
                  retinaMode: RetinaMode.isHighDensity(context),
                  // Choose any of these free tile providers:
                  //urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // Standard OSM
                  // urlTemplate: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', // Humanitarian style
                  // urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png', // CartoDB Voyager
                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', // CartoDB Positron
                  // urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', // CartoDB Dark Matter
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: state.visiblePeople.map((person) => Marker(
                    point: person['position'],
                    width: 100,
                    height: 100,
                    child:
                      ProfileAvatar(avatarLink: person['avatar'], color: person['color'], scale: 80)
                    )
                  ).toList(),
                )
              ],
            ),
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
    );
  }
}
