// lib/core/controllers/map_controller.dart
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/features/map/domain/controllers/map_controller_interface.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart' as map_event;
import 'package:localplayer/features/match/domain/entities/user_profile.dart';

class MapController implements IMapController {
  final BuildContext context;
  final Function(map_event.MapEvent) addEvent;

  double _currentZoom = 13.0;
  LatLngBounds? _currentBounds;
  List<ProfileWithSpotify> _visiblePeople = [];


  MapController(this.context, this.addEvent);

  @override
  void selectProfile(ProfileWithSpotify profile) {
    addEvent(map_event.SelectPlayer(profile.user));
  }

  @override
  void requestJoinSession(ProfileWithSpotify profile) {
    addEvent(map_event.RequestJoinSession(profile.user));
  }

  @override
  void deselectProfile(ProfileWithSpotify profile) {
    addEvent(map_event.DeselectPlayer(profile.user));
  }

  @override
  void updateCameraPosition(
    double latitude,
    double longitude,
    List<ProfileWithSpotify> visiblePeople,
    LatLngBounds visibleBounds,
    double zoom,
  ) {
    _currentZoom = zoom;
    _currentBounds = visibleBounds;
    _visiblePeople = visiblePeople;

    addEvent(map_event.UpdateCameraPosition(
      latitude,
      longitude,
      visiblePeople.map((e) => e.user).toList(),
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