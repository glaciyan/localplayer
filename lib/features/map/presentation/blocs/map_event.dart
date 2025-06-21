import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/core/domain/models/profile.dart';

abstract class MapEvent {}

class InitializeMap extends MapEvent {}

class UpdateCameraPosition extends MapEvent {
  final double latitude;
  final double longitude;
  final List<Profile> visiblePeople;
  final LatLngBounds visibleBounds;
  final double zoom;

  UpdateCameraPosition(this.latitude, this.longitude, this.visiblePeople, this.visibleBounds, this.zoom);
}

class SelectPlayer extends MapEvent {
  final Profile selectedPerson;
  final List<Profile> visiblePeople;

  
  SelectPlayer(this.selectedPerson, this.visiblePeople);
}

class DeselectPlayer extends MapEvent {
  final Profile selectedPerson;
  final List<Profile> visiblePeople;


  DeselectPlayer(this.selectedPerson, this.visiblePeople);
}

class RequestJoinSession extends MapEvent {
  final Profile selectedPerson;
  final List<Profile> visiblePeople;


  RequestJoinSession(this.selectedPerson, this.visiblePeople);
}