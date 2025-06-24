import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';

import 'package:localplayer/core/widgets/profile_avatar.dart';
import 'package:localplayer/features/map/domain/interfaces/map_controller_interface.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:localplayer/features/map/presentation/blocs/map_state.dart';
import 'package:localplayer/features/map/utils/marker_utils.dart';
import 'package:localplayer/features/map/map_module.dart';
import 'package:localplayer/core/widgets/profile_card.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  static const int maxOnScreen = 5;
  static const int maxListeners = 1000000;

  @override
  Widget build(final BuildContext context) {
    final IMapController mapController = MapModule.provideController(context, context.read<MapBloc>());

    return BlocBuilder<MapBloc, MapState>(
      builder: (final BuildContext context, final MapState state) {
        List<ProfileWithSpotify> sortedPeople = <ProfileWithSpotify>[];
        double currentZoom = 13.0;

        if (state is MapReady || state is MapProfileSelected) {
          final List<ProfileWithSpotify> visiblePeople = (state as dynamic).visiblePeople;
          currentZoom = (state as dynamic).zoom;

          sortedPeople = List<ProfileWithSpotify>.from(visiblePeople)
            ..sort((final ProfileWithSpotify a, final ProfileWithSpotify b) => _getListeners(b.user).compareTo(_getListeners(a.user)));
        }

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
                  initialCenter: LatLng(51.509364, -0.128928),
                  initialZoom: 13.0,
                  maxZoom: 20,
                  onPositionChanged: (final MapCamera position, final bool hasGesture) {
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
                children: <Widget> [
                  TileLayer(
                    retinaMode: RetinaMode.isHighDensity(context),
                    urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                    subdomains: <String> ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.app',
                  ),
                  if (state is MapReady || state is MapProfileSelected)
                    MarkerLayer(
                      markers: sortedPeople
                          .take(maxOnScreen)
                          .map((final ProfileWithSpotify profile) {
                            final UserProfile user = profile.user;
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
                      onVerticalDragDown: (final DragDownDetails details) {
                        if (details.globalPosition.dy < 100) {
                          mapController.deselectProfile(state.selectedUser);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: <Widget>[
                            ProfileCard(profile: state.selectedUser),

                            Positioned(
                              top: 12,
                              right: 12,
                              child: GestureDetector(
                                onTap: () => mapController.deselectProfile(state.selectedUser),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(Icons.close, color: Colors.white),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
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

  int _getListeners(final UserProfile user) => user.listeners ?? 0;

  LatLng _getLatLng(final UserProfile user) => user.position;
}