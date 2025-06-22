import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';

import 'package:localplayer/core/widgets/profile_avatar.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:localplayer/features/map/presentation/blocs/map_state.dart';
import 'package:localplayer/features/map/utils/marker_utils.dart';
import 'package:localplayer/core/modules/map_module.dart';
import 'package:localplayer/core/widgets/profile_card.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  final int maxOnScreen = 5;
  final int maxListeners = 1000000;

  @override
  Widget build(BuildContext context) {
    final mapController = MapModule.provideController(context, context.read<MapBloc>());

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        List<ProfileWithSpotify> sortedPeople = [];
        double currentZoom = 13.0;

        if (state is MapReady || state is MapProfileSelected) {
          final visiblePeople = (state as dynamic).visiblePeople;
          currentZoom = (state as dynamic).zoom;

          sortedPeople = List<ProfileWithSpotify>.from(visiblePeople)
            ..sort((a, b) => _getListeners(b.user).compareTo(_getListeners(a.user)));
        }

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
                  initialCenter: LatLng(51.509364, -0.128928),
                  initialZoom: 13.0,
                  maxZoom: 20,
                  onPositionChanged: (position, hasGesture) {
                    if (state is MapReady) {
                      mapController.updateCameraPosition(
                        position.center.latitude,
                        position.center.longitude,
                        state.visiblePeople,
                        position.visibleBounds,
                        position.zoom,
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
                  if (state is MapReady || state is MapProfileSelected)
                    MarkerLayer(
                      markers: sortedPeople
                          .take(maxOnScreen)
                          .map((profile) {
                            final user = profile.user;
                            final int listenerCount = _getListeners(user);
                            final double scale = calculateScale(listenerCount, maxListeners: maxListeners);

                            return Marker(
                              point: _getLatLng(user),
                              width: 100 * scale * currentZoom / 10,
                              height: 100 * scale * currentZoom / 10,
                              child: GestureDetector(
                                onTap: () {
                                  mapController.selectProfile(profile);
                                },
                                child: ProfileAvatar(
                                  avatarLink: profile.artist.imageUrl,
                                  color: user.color ?? Colors.blue,
                                  scale: scale,
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                ],
              ),

              if (state is MapProfileSelected)
                SafeArea(
                  child: Center(
                    child: GestureDetector(
                      onDoubleTap: () {
                        mapController.deselectProfile(state.selectedUser);
                      },
                      onVerticalDragDown: (details) {
                        if (details.globalPosition.dy < 100) {
                          mapController.deselectProfile(state.selectedUser);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            ProfileCard(profile: state.selectedUser),
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
                                          minimumSize: const Size(200, 60),
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        onPressed: () {
                                          mapController.requestJoinSession(state.selectedUser);
                                        },
                                        child: Text(
                                          'Request to join Session',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
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
      },
    );
  }

  int _getListeners(UserProfile user) {
    return user.listeners ?? 0;
  }

  LatLng _getLatLng(UserProfile user) {
    return user.position ?? LatLng(51.509364, -0.128928);
  }
}
