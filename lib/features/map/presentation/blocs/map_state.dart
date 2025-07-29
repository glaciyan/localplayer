import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart'; 
import 'package:localplayer/core/entities/user_profile.dart';

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
  final List<UserProfile> visiblePeople;
  final double zoom;
  final UserProfile me;
  MapReady({
    required this.latitude,
    required this.longitude,
    required this.visibleBounds,
    required this.visiblePeople,
    required this.zoom,
    required this.me,
  });

  MapReady copyWith({
    final double? latitude,
    final double? longitude,
    final LatLngBounds? visibleBounds,
    final List<UserProfile>? visiblePeople,
    final double? zoom,
    final UserProfile? me,
  }) => MapReady(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      visibleBounds: visibleBounds ?? this.visibleBounds,
      visiblePeople: visiblePeople ?? this.visiblePeople,
      zoom: zoom ?? this.zoom,
      me: me ?? this.me,
    );
}

class MapProfileSelected extends MapState {
  final double latitude;
  final double longitude;
  final LatLngBounds visibleBounds;
  final List<UserProfile> visiblePeople;
  final double zoom;
  final ProfileWithSpotify selectedUser;
  final UserProfile me;
  MapProfileSelected({
    required this.latitude,
    required this.longitude,
    required this.visibleBounds,
    required this.visiblePeople,
    required this.zoom,
    required this.selectedUser,
    required this.me,
  });

  MapProfileSelected copyWith({
    final double? latitude,
    final double? longitude,
    final LatLngBounds? visibleBounds,
    final List<UserProfile>? visiblePeople,
    final double? zoom,
    final ProfileWithSpotify? selectedUser,
    final UserProfile? me,
  }) => MapProfileSelected(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      visibleBounds: visibleBounds ?? this.visibleBounds,
      visiblePeople: visiblePeople ?? this.visiblePeople,
      zoom: zoom ?? this.zoom,
      selectedUser: selectedUser ?? this.selectedUser,
      me: me ?? this.me,
    );
}
