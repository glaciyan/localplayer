import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:localplayer/core/widgets/profile_avatar.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:localplayer/features/map/presentation/blocs/map_state.dart';
import 'package:localplayer/features/map/utils/marker_utils.dart';
import 'package:localplayer/core/modules/map_module.dart';
import 'package:localplayer/core/widgets/profile_card.dart';

class MapWidget extends StatelessWidget {  
  const MapWidget({super.key});

  final int maxOnScreen = 5;
  final double minScale = 0.75;
  final double maxScale = 1.125;
  final int maxListeners = 1000000;

  @override
  Widget build(BuildContext context) {
    final mapController = MapModule.provideController(context, context.read<MapBloc>());

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        final sortedPeople = (state is MapReady)
            ? (state.visiblePeople
                .where((person) => person['listeners'] != null)
                .toList()
              ..sort((a, b) => (b['listeners'] as int).compareTo(a['listeners'] as int)))
            : <Map<String, dynamic>>[];

        return Scaffold(
          body: Stack(
            children: [
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
                  onPositionChanged: (position, hasGesture) {
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
                children: [
                  TileLayer(
                    retinaMode: RetinaMode.isHighDensity(context),
                    urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                    subdomains: ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.app',
                  ),
                  if (state is MapReady)
                    MarkerLayer(
                      markers: sortedPeople.map((person) {
                        final int listenerCount = person['listeners'] ?? 0;
                        final double scale = calculateScale(listenerCount, maxListeners: maxListeners);

                        return Marker(
                          point: person['position'],
                          width: 100 * scale * state.zoom/10,
                          height: 100 * scale * state.zoom/10,
                          child: GestureDetector(
                            onTap: () {
                              mapController.selectProfile(person);
                            },
                            child: ProfileAvatar(
                              avatarLink: person['avatar'],
                              color: person['color'],
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
                      onVerticalDragDown: (details) {
                        if(details.globalPosition.dy < 100) {
                          mapController.deselectProfile(state.selectedPerson);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            ProfileCard(
                              avatarLink: state.selectedPerson['avatar'],
                              backgroundLink: state.selectedPerson['background'] ?? state.selectedPerson['avatar'],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
    
                                          minimumSize: Size(200, 60),
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        onPressed: () {
                                          print('Request to join Session of ${state.selectedPerson}');
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