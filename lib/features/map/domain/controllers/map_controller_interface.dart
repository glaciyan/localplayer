import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';

abstract class IMapController {
  void selectProfile(final ProfileWithSpotify profile);

  void requestJoinSession(final ProfileWithSpotify profile);

  void deselectProfile(final ProfileWithSpotify profile);

  void updateCameraPosition(
    final double latitude,
    final double longitude,
    final List<ProfileWithSpotify> visiblePeople,
    final LatLngBounds visibleBounds,
    final double zoom,
  );
  double get currentZoom;

  LatLngBounds get currentBounds;

  List<ProfileWithSpotify> get visiblePeople;
}
