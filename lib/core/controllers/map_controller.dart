// lib/core/controllers/map_controller.dart
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/core/domain/interfaces/map_controller_interface.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart' as map_event;

class MapController implements IMapController {
  final BuildContext context;
  final Function(map_event.MapEvent) addEvent;
  double _currentZoom = 13.0;
  LatLngBounds? _currentBounds;
  List<Map<String, dynamic>> _visiblePeople = [];

  MapController(this.context, this.addEvent);

  @override
  void selectProfile(Map<String, dynamic> profile) {
    addEvent(map_event.SelectPlayer(profile));
  }

  @override
  void requestJoinSession(Map<String, dynamic> profile) {
    addEvent(map_event.RequestJoinSession(profile));
  }
  
  @override
  void deselectProfile(Map<String, dynamic> profile) {
    addEvent(map_event.DeselectPlayer(profile));
  }


  @override
  void updateCameraPosition(
    double latitude,
    double longitude,
    List<Map<String, dynamic>> visiblePeople,
    LatLngBounds visibleBounds,
    double zoom,
  ) {
    _currentZoom = zoom;
    _currentBounds = visibleBounds;
    _visiblePeople = visiblePeople;
    
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
  List<Map<String, dynamic>> get visiblePeople => _visiblePeople;
}