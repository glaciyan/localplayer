import 'package:flutter_map/flutter_map.dart';

abstract class MapEvent {}

class InitializeMap extends MapEvent {}

class UpdateCameraPosition extends MapEvent {
  final double latitude;
  final double longitude;
  final List<Map<String, dynamic>> visiblePeople;
  final LatLngBounds visibleBounds;
  final double zoom;

  UpdateCameraPosition(this.latitude, this.longitude, this.visiblePeople, this.visibleBounds, this.zoom);
}

class SelectPlayer extends MapEvent {
  final Map<String, dynamic> selectedPerson;
  
  SelectPlayer(this.selectedPerson);
}

class DeselectPlayer extends MapEvent {
  final Map<String, dynamic> selectedPerson;

  DeselectPlayer(this.selectedPerson);
}

class RequestJoinSession extends MapEvent {
  final Map<String, dynamic> selectedPerson;

  RequestJoinSession(this.selectedPerson);
}