import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/core/domain/models/profile.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapReady extends MapState {
  final double latitude;
  final double longitude;
  final LatLngBounds visibleBounds;
  final List<Profile> visiblePeople;
  final double zoom;

  MapReady({
    required this.latitude, 
    required this.longitude,
    required this.visibleBounds,
    required this.visiblePeople,
    required this.zoom
  });

  MapReady copyWith({
    final double? latitude,
    final double? longitude,
    final LatLngBounds? visibleBounds,
    final List<Profile>? visiblePeople,
    final double? scale
  }) => MapReady(
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    visibleBounds: visibleBounds ?? this.visibleBounds,
    visiblePeople: visiblePeople ?? this.visiblePeople,
    zoom: scale ?? this.zoom,
  );
}

class MapProfileSelected extends MapState {
  final double latitude;
  final double longitude;
  final LatLngBounds visibleBounds;
  final List<Profile> visiblePeople;
  final double zoom;
  final Profile selectedPerson;

  MapProfileSelected({
    required this.latitude, 
    required this.longitude,
    required this.visibleBounds,
    required this.visiblePeople,
    required this.zoom,
    required this.selectedPerson
  });

  MapProfileSelected copyWith({
    final double? latitude,
    final double? longitude,
    final LatLngBounds? visibleBounds,
    final List<Profile>? visiblePeople,
    final double? zoom,
    final Profile? selectedPerson
  }) => MapProfileSelected(
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    visibleBounds: visibleBounds ?? this.visibleBounds,
    visiblePeople: visiblePeople ?? this.visiblePeople,
    zoom: zoom ?? this.zoom,
    selectedPerson: selectedPerson ?? this.selectedPerson,
  );
}