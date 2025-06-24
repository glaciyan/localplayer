// lib/core/controllers/map_controller.dart
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/features/map/domain/interfaces/map_controller_interface.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart' as map_event;


class MapController implements IMapController {
  final BuildContext context;
  final Function(map_event.MapEvent) addEvent;

  double _currentZoom = 13.0;
  LatLngBounds? _currentBounds;
  List<ProfileWithSpotify> _visiblePeople = <ProfileWithSpotify>[];


  MapController(this.context, this.addEvent);

  @override
  void selectProfile(final ProfileWithSpotify profile) {
    addEvent(map_event.SelectPlayer(profile.user));
  }

  @override
  void requestJoinSession(final ProfileWithSpotify profile) {
    addEvent(map_event.RequestJoinSession(profile.user));
  }

  @override
  void deselectProfile(final ProfileWithSpotify profile) {
    addEvent(map_event.DeselectPlayer(profile.user));

    if (_currentBounds != null) {
      updateCameraPosition(
        _currentBounds!.center.latitude,
        _currentBounds!.center.longitude,
        _visiblePeople,
        _currentBounds!,
        _currentZoom,
      );
    }
  }


  @override
  void updateCameraPosition(
    final double latitude,
    final double longitude,
    final List<ProfileWithSpotify> visiblePeople,
    final LatLngBounds visibleBounds,
    final double zoom,
  ) {
    _currentZoom = zoom;
    _currentBounds = visibleBounds;
    _visiblePeople = visiblePeople;

    addEvent(map_event.UpdateCameraPosition(
      latitude,
      longitude,
      visiblePeople.map((final ProfileWithSpotify profile) => profile.user).toList(),
      visibleBounds,
      zoom,
    ));
  }

  @override
  double get currentZoom => _currentZoom;

  @override
  LatLngBounds get currentBounds =>
      _currentBounds ?? LatLngBounds(LatLng(0, 0), LatLng(0, 0));

  @override
  List<ProfileWithSpotify> get visiblePeople => _visiblePeople;
}