import 'package:flutter_map/flutter_map.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapReady extends MapState {
  final double latitude;
  final double longitude;
  final LatLngBounds visibleBounds;
  final List<Map<String, dynamic>> visiblePeople;
  final double zoom;

  MapReady({
    required this.latitude, 
    required this.longitude,
    required this.visibleBounds,
    required this.visiblePeople,
    required this.zoom
  });

  MapReady copyWith({
    double? latitude,
    double? longitude,
    LatLngBounds? visibleBounds,
    List<Map<String, dynamic>>? visiblePeople,
    double? scale
  }) {
    return MapReady(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      visibleBounds: visibleBounds ?? this.visibleBounds,
      visiblePeople: visiblePeople ?? this.visiblePeople,
      zoom: scale ?? this.zoom,
    );
  }
}

class MapProfileSelected extends MapState {
  final double latitude;
  final double longitude;
  final LatLngBounds visibleBounds;
  final List<Map<String, dynamic>> visiblePeople;
  final double zoom;
  final Map<String, dynamic> selectedPerson;

  MapProfileSelected({
    required this.latitude, 
    required this.longitude,
    required this.visibleBounds,
    required this.visiblePeople,
    required this.zoom,
    required this.selectedPerson
  });

  MapProfileSelected copyWith({
    double? latitude,
    double? longitude,
    LatLngBounds? visibleBounds,
    List<Map<String, dynamic>>? visiblePeople,
    double? zoom,
    Map<String, dynamic>? selectedPerson
  }) {
    return MapProfileSelected(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      visibleBounds: visibleBounds ?? this.visibleBounds,
      visiblePeople: visiblePeople ?? this.visiblePeople,
      zoom: zoom ?? this.zoom,
      selectedPerson: selectedPerson ?? this.selectedPerson,
    );
  }
}