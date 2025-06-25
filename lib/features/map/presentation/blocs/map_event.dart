import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/core/entities/user_profile.dart';

abstract class MapEvent {}

class InitializeMap extends MapEvent {}

class UpdateCameraPosition extends MapEvent {
  final double latitude;
  final double longitude;
  final List<UserProfile> visiblePeople;
  final LatLngBounds visibleBounds;
  final double zoom;

  UpdateCameraPosition(this.latitude, this.longitude, this.visiblePeople, this.visibleBounds, this.zoom);
}
class LoadMapProfiles extends MapEvent {
  LoadMapProfiles();
}

class SelectPlayer extends MapEvent {
  final UserProfile selectedUser;

  SelectPlayer(this.selectedUser);
}

class DeselectPlayer extends MapEvent {
  final UserProfile selectedUser;
  final double latitude;
  final double longitude;
  final LatLngBounds visibleBounds;
  final double zoom;

  DeselectPlayer(
    this.selectedUser,
    this.latitude,
    this.longitude,
    this.visibleBounds,
    this.zoom,
  );
}
class RequestJoinSession extends MapEvent {
  final UserProfile selectedUser;

  RequestJoinSession(this.selectedUser);
}
