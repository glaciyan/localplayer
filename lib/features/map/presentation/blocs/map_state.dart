import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';

abstract class MapState {}

class MapInitial extends MapState {}
class MapLoading extends MapState {}
class MapError extends MapState {
  final String message;

  MapError(this.message);
}

class MapReady extends MapState {
  final double latitude;
  final double longitude;
  final LatLngBounds visibleBounds;
  final List<ProfileWithSpotify> visiblePeople;
  final double zoom;

  MapReady({
    required this.latitude,
    required this.longitude,
    required this.visibleBounds,
    required this.visiblePeople,
    required this.zoom,
  });

  MapReady copyWith({
    final double? latitude,
    final double? longitude,
    final LatLngBounds? visibleBounds,
    final List<ProfileWithSpotify>? visiblePeople,
    final double? zoom,
  }) => MapReady(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      visibleBounds: visibleBounds ?? this.visibleBounds,
      visiblePeople: visiblePeople ?? this.visiblePeople,
      zoom: zoom ?? this.zoom,
    );
}

class MapProfileSelected extends MapState {
  final double latitude;
  final double longitude;
  final LatLngBounds visibleBounds;
  final List<ProfileWithSpotify> visiblePeople;
  final double zoom;
  final ProfileWithSpotify selectedUser;

  MapProfileSelected({
    required this.latitude,
    required this.longitude,
    required this.visibleBounds,
    required this.visiblePeople,
    required this.zoom,
    required this.selectedUser,
  });

  MapProfileSelected copyWith({
    final double? latitude,
    final double? longitude,
    final LatLngBounds? visibleBounds,
    final List<ProfileWithSpotify>? visiblePeople,
    final double? zoom,
    final ProfileWithSpotify? selectedUser,
  }) => MapProfileSelected(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      visibleBounds: visibleBounds ?? this.visibleBounds,
      visiblePeople: visiblePeople ?? this.visiblePeople,
      zoom: zoom ?? this.zoom,
      selectedUser: selectedUser ?? this.selectedUser,
    );
}
