// lib/core/controllers/map_controller.dart
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/features/map/domain/interfaces/map_controller_interface.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart' as map_event;
import 'dart:async';

import 'package:localplayer/main.dart';


class MapController implements IMapController {
  final BuildContext context;
  final Function(map_event.MapEvent) addEvent;
  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 600);

  double _currentZoom = 13.0;
  LatLngBounds? _currentBounds;
  List<UserProfile> _visiblePeople = <UserProfile>[];

  MapController(this.context, this.addEvent);

  @override
  void selectProfile(final UserProfile profile) {
    addEvent(map_event.SelectPlayer(profile));
  }

  @override
  void requestJoinSession(final ProfileWithSpotify profile) {

    log.i('Request to join Session for user: ${profile.user.displayName}');
    final int sessionId = profile.user.id;
    log.i('Attempting to join session: $sessionId');
    addEvent(map_event.RequestJoinSession(profile.user));
  }

  @override
  void deselectProfile(final ProfileWithSpotify profile) {
    final LatLng pos = profile.user.position;
    final LatLngBounds fallbackBounds = LatLngBounds(
      LatLng(pos.latitude - 0.01, pos.longitude - 0.01),
      LatLng(pos.latitude + 0.01, pos.longitude + 0.01),
    );

    final LatLngBounds bounds = _currentBounds ?? fallbackBounds;

    addEvent(
      map_event.DeselectPlayer(
        profile.user,
        bounds.center.latitude,
        bounds.center.longitude,
        bounds,
        _currentZoom,
      ),
    );
  }

  @override
  void updateCameraPosition(
    final double latitude,
    final double longitude,
    final List<UserProfile> visiblePeople,
    final LatLngBounds visibleBounds,
    final double zoom,
  ) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDelay, () {
      _currentBounds = visibleBounds;
      _visiblePeople = visiblePeople;
      _currentZoom = zoom;

      addEvent(map_event.UpdateCameraPosition(
        latitude,
        longitude,
        visiblePeople,
        visibleBounds,
        zoom,
      ));
    });
  }

  @override
  double get currentZoom => _currentZoom;

  @override
  LatLngBounds get currentBounds =>
      _currentBounds ?? LatLngBounds(LatLng(0, 0), LatLng(0, 0));

  @override
  List<UserProfile> get visiblePeople => _visiblePeople;

  void dispose() {
    _debounceTimer?.cancel();
  }
}