import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/core/domain/models/profile.dart';

import 'package:localplayer/core/widgets/profile_avatar.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:localplayer/features/map/presentation/blocs/map_state.dart';
import 'package:localplayer/features/map/utils/marker_utils.dart';
import 'package:localplayer/features/map/map_module.dart';
import 'package:localplayer/core/widgets/profile_card.dart';
import 'package:localplayer/features/map/domain/interfaces/map_controller_interface.dart';

class MapWidget extends StatelessWidget {  
  const MapWidget({super.key});

  static final int maxOnScreen = 10;
  static final double minScale = 0.75;
  static final double maxScale = 1;
  static final int maxListeners = 1000000;

  @override
  Widget build(final BuildContext context) {
    final IMapController mapController = MapModule.provideController(context, context.read<MapBloc>());

    return BlocBuilder<MapBloc, MapState>(
      builder: (final BuildContext context, final MapState state) {
        final List<Profile> sortedPeople = (state is MapReady)
            ? (state.visiblePeople
                .where((final Profile person) => person.listeners > 0)
                .toList()
              ..sort((final Profile a, final Profile b) => (b.listeners).compareTo(a.listeners)))
            : <Profile>[];

        return Scaffold(
          body: Stack(
            children: <Widget> [
              FlutterMap(
                options: MapOptions(
                  initialRotation: 0.0,
                  interactionOptions: InteractionOptions(
                    rotationThreshold: 360,
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                  initialCenter: LatLng(51.509364, -0.128928), // London
                  initialZoom: 13.0,
                  maxZoom: 20,
                  onPositionChanged: (final MapCamera position, final bool hasGesture) {
                    if (state is MapReady) {
                      mapController.updateCameraPosition(
                        position.center.latitude,
                        position.center.longitude,
                        state.visiblePeople,
                        position.visibleBounds,
                        position.zoom
                      );
                    }
                  },
                ),
                children: <Widget> [
                  TileLayer(
                    retinaMode: RetinaMode.isHighDensity(context),
                    urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                    subdomains: <String> ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.app',
                  ),
                  if (state is MapReady)
                    MarkerLayer(
                      markers: sortedPeople.map((final Profile person) {
                        final int listenerCount = person.listeners;
                        final double scale = calculateScale(listenerCount, maxListeners: maxListeners);

                        return Marker(
                          point: person.position,
                          width: 100 * scale * state.zoom/10,
                          height: 100 * scale * state.zoom/10,
                          child: GestureDetector(
                            onTap: () {
                              mapController.selectProfile(person);
                            },
                            child: ProfileAvatar(
                              avatarLink: person.avatarUrl,
                              color: person.color,
                              scale: scale,
                            ),
                          ),
                        );
                      })
                      .take(maxOnScreen)
                      .toList(),
                    ),
                ],
              ),
              if (state is MapProfileSelected)
                SafeArea(
                  child: Center(
                    child: GestureDetector(
                      onDoubleTap: () {
                        mapController.deselectProfile(state.selectedPerson);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: <Widget> [
                            ProfileCard(
                              backgroundLink: state.selectedPerson.backgroundUrl,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget> [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget> [
                                      IconButton(
                                        onPressed: () {
                                          mapController.deselectProfile(state.selectedPerson);
                                        },
                                        icon: Icon(Icons.close, size: 40, color: Theme.of(context).colorScheme.onPrimary),
                                      ),
                                    ]
                                  )
                              ])
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget> [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget> [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(200, 60),
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        onPressed: () {
                                          mapController.requestJoinSession(state.selectedPerson);
                                        },
                                        child: Text('Request to join Session', 
                                          style: Theme.of(context).textTheme.bodyMedium
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }
    );
  }
}