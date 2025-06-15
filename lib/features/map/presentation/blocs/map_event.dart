import 'package:flutter_map/flutter_map.dart';

abstract class MapEvent {}

class InitializeMap extends MapEvent {}

class UpdateCameraPosition extends MapEvent {
  final double latitude;
  final double longitude;
  final List<Map<String, dynamic>> visiblePeople;
  final LatLngBounds visibleBounds;

  UpdateCameraPosition(this.latitude, this.longitude, this.visiblePeople, this.visibleBounds);
}