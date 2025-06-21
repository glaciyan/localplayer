// lib/core/controllers/map_controller.dart
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/features/map/domain/interfaces/map_controller_interface.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart' as map_event;
import 'package:localplayer/core/domain/models/profile.dart';

class MapController implements IMapController {
  final BuildContext context;
  final Function(map_event.MapEvent) addEvent;
  double _currentZoom = 13.0;
  LatLngBounds? _currentBounds;
  final List<Profile> _visiblePeople = <Profile> [];

  MapController(this.context, this.addEvent);

  @override
  void selectProfile(final Profile profile) {
    addEvent(map_event.SelectPlayer(profile, _visiblePeople));
  }

  @override
  void requestJoinSession(final Profile profile) {
    addEvent(map_event.RequestJoinSession(profile, _visiblePeople));
  }
  
  @override
  void deselectProfile(final Profile profile) {
    addEvent(map_event.DeselectPlayer(profile, _visiblePeople));
  }


  @override
  void updateCameraPosition(
    final double latitude,
    final double longitude,
    final List<Profile> visiblePeople,
    final LatLngBounds visibleBounds,
    final double zoom,
  ) {
    _currentZoom = zoom;
    _currentBounds = visibleBounds;
    _visiblePeople.clear();
    _visiblePeople.addAll(visiblePeople);
    
    addEvent(map_event.UpdateCameraPosition(
      latitude,
      longitude,
      visiblePeople,
      visibleBounds,
      zoom,
    ));
  }

  @override
  double get currentZoom => _currentZoom;

  @override
  LatLngBounds get currentBounds => _currentBounds ?? LatLngBounds(
    LatLng(0, 0),
    LatLng(0, 0),
  );

  @override
  List<Profile> get visiblePeople => _visiblePeople;
}