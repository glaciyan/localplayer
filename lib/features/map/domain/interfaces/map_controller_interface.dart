import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/core/domain/models/profile.dart';


abstract class IMapController {
  /// Selects a profile on the map and shows its details
  void selectProfile(final Profile profile);

  /// Requests to join a session
  void requestJoinSession(final Profile profile);

  /// Closes the currently selected profile
  void deselectProfile(final Profile profile);

  /// Updates the camera position and visible area
  void updateCameraPosition(
    final double latitude,
    final double longitude,
    final List<Profile> visiblePeople,
    final LatLngBounds visibleBounds,
    final double zoom,
  );

  /// Gets the current zoom level
  double get currentZoom;

  /// Gets the current visible bounds
  LatLngBounds get currentBounds;

  /// Gets the list of currently visible people
  List<Profile> get visiblePeople;
}