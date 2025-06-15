import 'package:flutter_map/flutter_map.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapReady extends MapState {
  final double latitude;
  final double longitude;
  final LatLngBounds visibleBounds;
  final List<Map<String, dynamic>> visiblePeople;


  MapReady({
    required this.latitude, 
    required this.longitude,
    required this.visibleBounds,
    required this.visiblePeople  
  });

  MapReady copyWith({
    double? latitude,
    double? longitude,
    LatLngBounds? visibleBounds,
    List<Map<String, dynamic>>? visiblePeople,
  }) {
    return MapReady(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      visibleBounds: visibleBounds ?? this.visibleBounds,
      visiblePeople: visiblePeople ?? this.visiblePeople,
    );
  }
}
