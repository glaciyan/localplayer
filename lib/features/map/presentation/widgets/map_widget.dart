import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/services/spotify/data/services/spotify_audio_service.dart';
import 'package:localplayer/core/widgets/profile_avatar.dart';
import 'package:localplayer/features/map/domain/interfaces/map_controller_interface.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:localplayer/features/map/presentation/blocs/map_state.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart';
import 'package:localplayer/features/map/utils/marker_utils.dart';
import 'package:localplayer/features/map/map_module.dart';
import 'package:localplayer/core/widgets/profile_card.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  static const int maxOnScreen = 20;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  MapController? _mapController;
  bool _isLoadingRequest = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapBloc>().add(LoadMapProfiles());
    });
  }

  @override
  void dispose() {
    SpotifyAudioService().stop();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final IMapController mapController =
        MapModule.provideController(context, context.read<MapBloc>());

    return BlocListener<MapBloc, MapState>(
      listener: (final BuildContext context, final MapState state) {
        if (state is MapReady && _mapController != null) {
          _mapController!.move(
            LatLng(state.latitude, state.longitude),
            state.zoom,
          );
        }
      },
      child: BlocBuilder<MapBloc, MapState>(
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
                mapController: _mapController,
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
                          .take(MapWidget.maxOnScreen)
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
                                onTap: () {
                                  SpotifyAudioService().stop();
                                  mapController.deselectProfile(state.selectedUser);
                                  },
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

                            if (state.selectedUser.user.sessionStatus == 'OPEN' || state.selectedUser.user.sessionStatus == 'CLOSED') ...<Widget>[
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                height: 300,
                                child: IgnorePointer(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: <Color>[Colors.black, Colors.transparent],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Button
                              Padding(
                                padding: const EdgeInsets.all(60.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: _isLoadingRequest ? null : () async {
                                              setState(() {
                                                _isLoadingRequest = true;  // Start loading
                                              });
                                                                                            
                                              try {
                                                if (state.me.participating != null && state.me.participating == state.selectedUser.user.sessionId) {
                                                  // Requested state - leave/cancel the request
                                                  context.read<MapBloc>().add(LeaveSession());
                                                } else if (state.me.participating != null) {
                                                  // In different session - leave current session
                                                  context.read<MapBloc>().add(LeaveSession());
                                                } else {
                                                  // Can request to join
                                                  mapController.requestJoinSession(state.selectedUser);
                                                }
                                              } finally {
                                                // Stop loading after a delay to allow the request to complete
                                                await Future<dynamic>.delayed(const Duration(milliseconds: 1500));
                                                setState(() {
                                                  _isLoadingRequest = false;  // Stop loading
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(10, 60),
                                              backgroundColor: _isLoadingRequest ? Colors.grey : _getButtonColor(state),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: _isLoadingRequest 
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  ),
                                                )
                                              : Text(
                                                  _getButtonText(state),
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
      ),
    );
  }

  int _getPopularity(final UserProfile user) => user.popularity ?? 0;

  LatLng _getLatLng(final UserProfile user) => user.position;

  Color _getButtonColor(final MapState state) {
    if (state is! MapProfileSelected) return Colors.green;
        
    if (state.me.participating != null && state.me.participating == state.selectedUser.user.sessionId) {
      return Colors.blue; // Request sent
    } else if (state.me.participating != null) {
      return Colors.orange; // In different session
    } else {
      return Colors.green; // Can request to join
    }
  }

  String _getButtonText(final MapState state) {
    if (state is! MapProfileSelected) return 'Request to join Session';
    
    if (state.me.participating != null && state.me.participating == state.selectedUser.user.sessionId) {
      return 'Leave / Cancel Request'; // Request sent
    } else if (state.me.participating != null) {
      return 'Leave Current Session';
    } else {
      return 'Request to join Session';
    }
  }
}