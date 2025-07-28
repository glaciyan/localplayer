import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/features/map/data/map_repository_interface.dart';
import 'package:localplayer/core/network/no_connection_exception.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'dart:async';
import 'package:localplayer/features/map/utils/marker_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MapBloc extends Bloc<MapEvent, MapState> {
  final IMapRepository mapRepository;
  final ISpotifyRepository spotifyRepository;

  List<UserProfile> _allProfiles = <UserProfile> [];
  Timer? _debounceTimer;

  MapBloc({
    required this.mapRepository,
    required this.spotifyRepository,
  }) : super(MapInitial()) {
    on<LoadMapProfiles>(_onLoadMapProfiles);
    on<InitializeMap>(_onInitializeMap);
    on<UpdateCameraPosition>(_onUpdateCameraPosition);
    on<SelectPlayer>(_onSelectPlayer);
    on<DeselectPlayer>(_onDeselectPlayer);
    on<RequestJoinSession>(_onRequestJoinSession);
  }

  Future<void> _onLoadMapProfiles(final LoadMapProfiles event, final Emitter<MapState> emit) async {
    emit(MapLoading());
    try {
      const double initLatitude = 52.52;
      const double initLongitude = 13.405;
      const double initZoom = 10.5;


      
      _allProfiles = await mapRepository.fetchProfiles(initLatitude, initLongitude, initZoom);
      add(InitializeMap());
    } on NoConnectionException {
      emit(MapError('No internet connection'));
    } catch (e) {
      emit(MapError("Failed to load map profiles: $e"));
    }
  }

  void _onInitializeMap(final InitializeMap event, final Emitter<MapState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final double? userLat = prefs.getDouble('user_latitude');
    final double? userLng = prefs.getDouble('user_longitude');
    
    // Use stored location or fallback to default
    final double initLatitude = userLat ?? 47.6596;
    final double initLongitude = userLng ?? 9.1753;
    const double initZoom = 10.5;

    print('🗺️ Initializing map at user location: $initLatitude, $initLongitude');

    final flutter_map.LatLngBounds bounds = flutter_map.LatLngBounds(
      LatLng(initLatitude - 0.01, initLongitude - 0.01),
      LatLng(initLatitude + 0.01, initLongitude + 0.01),
    );

    final List<UserProfile> visible = _allProfiles;
    emit(MapReady(
      latitude: initLatitude,
      longitude: initLongitude,
      visiblePeople: visible,
      visibleBounds: bounds,
      zoom: initZoom,
    ));
  }

  void _onUpdateCameraPosition(
    final UpdateCameraPosition event,
    final Emitter<MapState> emit,
  ) async {
    final double radius = calculateRadiusFromBounds(event.visibleBounds);

    try {
      final List<UserProfile> profilesInRadius =
          await mapRepository.fetchProfiles(
        event.latitude,
        event.longitude,
        radius,
      );

      emit(MapReady(
        latitude: event.latitude,
        longitude: event.longitude,
        visiblePeople: profilesInRadius,
        visibleBounds: event.visibleBounds,
        zoom: event.zoom,
      ));
    } on NoConnectionException {
      emit(MapError('No internet connection'));
    } catch (e) {
      emit(MapError("Failed to fetch profiles: $e"));
    }
  }

  Future<void> _onSelectPlayer(final SelectPlayer event, final Emitter<MapState> emit) async {
    final LatLng pos = event.selectedUser.position;
    final flutter_map.LatLngBounds bounds = flutter_map.LatLngBounds(
      LatLng(pos.latitude - 0.01, pos.longitude - 0.01),
      LatLng(pos.latitude + 0.01, pos.longitude + 0.01),
    );

    try {
      emit(MapProfileSelected(
        latitude: pos.latitude,
        longitude: pos.longitude,
        visibleBounds: bounds,
        visiblePeople: _allProfiles,
        zoom: 12,
        selectedUser: await mapRepository.fetchProfileWithSpotify(event.selectedUser),
      ));
    } on NoConnectionException {
      emit(MapError('No internet connection'));
    } on TimeoutException {
      emit(MapError('Timeout'));
    } catch (_) {
      final ProfileWithSpotify selected = ProfileWithSpotify(
        user: event.selectedUser,
        artist: SpotifyArtistData(
          name: event.selectedUser.displayName,
          genres: 'Unknown',
          imageUrl: event.selectedUser.avatarLink,
          biography: event.selectedUser.biography,
          tracks: <TrackEntity>[],
          popularity: 0,
          listeners: 0,
        ),
      );

      emit(MapProfileSelected(
        latitude: pos.latitude,
        longitude: pos.longitude,
        visibleBounds: bounds,
        visiblePeople: _allProfiles,
        zoom: 12,
        selectedUser: selected,
      ));
    }
  }

  void _onDeselectPlayer(final DeselectPlayer event, final Emitter<MapState> emit) {
    final List<UserProfile> visible = _allProfiles
        .where(
          (final UserProfile profile) =>
              event.visibleBounds.contains(profile.position),
        )
        .toList();

    emit(
      MapReady(
        latitude: event.latitude,
        longitude: event.longitude,
        visiblePeople: visible,
        visibleBounds: event.visibleBounds,
        zoom: event.zoom,
      ),
    );
  }

  Future<void> _onRequestJoinSession(
    final RequestJoinSession event,
    final Emitter<MapState> emit,
  ) async {
    final LatLng pos = event.selectedUser.position;
    final flutter_map.LatLngBounds bounds = flutter_map.LatLngBounds(
      LatLng(pos.latitude - 0.01, pos.longitude - 0.01),
      LatLng(pos.latitude + 0.01, pos.longitude + 0.01),
    );

    try {
      final SpotifyArtistData artistData =
          await spotifyRepository.fetchArtistData(
        event.selectedUser.spotifyId,
      );
      final ProfileWithSpotify enriched = ProfileWithSpotify(
        user: event.selectedUser,
        artist: artistData,
      );

      emit(MapProfileSelected(
        latitude: pos.latitude,
        longitude: pos.longitude,
        visibleBounds: bounds,
        visiblePeople: _allProfiles,
        zoom: 12,
        selectedUser: enriched,
      ));
    } on NoConnectionException {
      emit(MapError('No internet connection'));
    } catch (_) {
      final ProfileWithSpotify enriched = ProfileWithSpotify(
        user: event.selectedUser,
        artist: SpotifyArtistData(
          name: event.selectedUser.displayName,
          genres: 'Unknown',
          imageUrl: event.selectedUser.avatarLink,
          biography: event.selectedUser.biography,
          tracks: <TrackEntity>[],
          popularity: 0,
          listeners: 0,
        ),
      );

      emit(MapProfileSelected(
        latitude: pos.latitude,
        longitude: pos.longitude,
        visibleBounds: bounds,
        visiblePeople: _allProfiles,
        zoom: 12,
        selectedUser: enriched,
      ));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
