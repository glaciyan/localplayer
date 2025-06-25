import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/widgets/profile_avatar.dart';
import 'package:localplayer/features/map/domain/interfaces/map_controller_interface.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:localplayer/features/map/presentation/blocs/map_state.dart';
import 'package:localplayer/features/map/utils/marker_utils.dart';
import 'package:localplayer/features/map/map_module.dart';
import 'package:localplayer/core/widgets/profile_card.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  static const int maxOnScreen = 10;

  @override
  Widget build(final BuildContext context) {
    final IMapController mapController =
        MapModule.provideController(context, context.read<MapBloc>());

    return BlocBuilder<MapBloc, MapState>(
      builder: (final BuildContext context, final MapState state) {
        List<UserProfile> sortedPeople = <UserProfile>[];
        double currentZoom = 13.0;
        int maxListeners = 1;

        if (state is MapReady || state is MapProfileSelected) {
          final List<UserProfile> visiblePeople = (state as dynamic).visiblePeople;
          currentZoom = (state as dynamic).zoom;

          sortedPeople = List<UserProfile>.from(visiblePeople)
            ..sort(
              (final UserProfile a, final UserProfile b) =>
                  _getPopularity(b).compareTo(
                _getPopularity(a),
              ),
            );
          if (sortedPeople.isNotEmpty) {
            maxListeners = sortedPeople.map(_getPopularity).reduce((final int a, final int b) => a > b ? a : b);
          }
        }

        if (state is MapError) {
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.red),
              ),
            ),
          );
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
                  initialCenter: LatLng(52.52, 13.405),
                  initialZoom: 10.5,
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
                          .map((final UserProfile profile) {
                            final int popularity = _getPopularity(profile);
                            final double scale =
                                calculateScale(
                              popularity,
                              maxListeners: maxListeners,
                            );

                            return Marker(
                              point: _getLatLng(profile),
                              width: 100 * scale * currentZoom / 10,
                              height: 100 * scale * currentZoom / 10,
                              child: GestureDetector(
                                onTap: () {
                                  mapController.selectProfile(profile);
                                },
                                child: ProfileAvatar(
                                  avatarLink: profile.avatarLink,
                                  color: profile.color ?? Colors.blue,
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
                            Positioned.fill(
                              child: ProfileCard(profile: state.selectedUser),
                            ),
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
                              padding: const EdgeInsets.all(60.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(150, 60),
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

  int _getPopularity(final UserProfile user) => user.popularity ?? 0;

  LatLng _getLatLng(final UserProfile user) => user.position;
}