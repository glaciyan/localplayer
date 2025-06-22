import 'package:flutter_map/flutter_map.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';

abstract class IMapController {
  void selectProfile(ProfileWithSpotify profile);

  void requestJoinSession(ProfileWithSpotify profile);

  void deselectProfile(ProfileWithSpotify profile);

  void updateCameraPosition(
    double latitude,
    double longitude,
    List<ProfileWithSpotify> visiblePeople,
    LatLngBounds visibleBounds,
    double zoom,
  );
  double get currentZoom;

  LatLngBounds get currentBounds;

  List<ProfileWithSpotify> get visiblePeople;
}
