import 'package:flutter_map/flutter_map.dart';


abstract class IMapController {
  /// Selects a profile on the map and shows its details
  void selectProfile(Map<String, dynamic> profile);

  /// Requests to join a session
  void requestJoinSession(Map<String, dynamic> profile);

  /// Closes the currently selected profile
  void deselectProfile(Map<String, dynamic> profile);

  /// Updates the camera position and visible area
  void updateCameraPosition(
    double latitude,
    double longitude,
    List<Map<String, dynamic>> visiblePeople,
    LatLngBounds visibleBounds,
    double zoom,
  );

  /// Gets the current zoom level
  double get currentZoom;

  /// Gets the current visible bounds
  LatLngBounds get currentBounds;

  /// Gets the list of currently visible people
  List<Map<String, dynamic>> get visiblePeople;
}