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
import 'package:localplayer/main.dart';
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
    on<UpdateCameraPosition>(_onUpdateCameraPosition);
    on<SelectPlayer>(_onSelectPlayer);
    on<DeselectPlayer>(_onDeselectPlayer);
    on<RequestJoinSession>(_onRequestJoinSession);
  }


  Future<void> _onLoadMapProfiles(final LoadMapProfiles event, final Emitter<MapState> emit) async {
    emit(MapLoading());
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final double? userLat = prefs.getDouble('user_latitude');
    final double? userLng = prefs.getDouble('user_longitude');
    
    final double initLatitude = userLat ?? 47.6596;
    final double initLongitude = userLng ?? 9.1753;

    const double initZoom = 10.5;
    
    add(UpdateCameraPosition(
      initLatitude,
      initLongitude,
      <UserProfile>[],
      flutter_map.LatLngBounds(
        LatLng(initLatitude - 0.01, initLongitude - 0.01),
        LatLng(initLatitude + 0.01, initLongitude + 0.01),
      ),
      initZoom,
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

  Future<void> _onDeselectPlayer(final DeselectPlayer event, final Emitter<MapState> emit) async {
    final double radius = calculateRadiusFromBounds(event.visibleBounds);

    try {
      final List<UserProfile> profilesInRadius = await mapRepository.fetchProfiles(
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

  Future<void> _onRequestJoinSession(
    final RequestJoinSession event,
    final Emitter<MapState> emit,
  ) async {
    final LatLng pos = event.selectedUser.position;
    final flutter_map.LatLngBounds bounds = flutter_map.LatLngBounds(
      LatLng(pos.latitude - 0.01, pos.longitude - 0.01),
      LatLng(pos.latitude + 0.01, pos.longitude + 0.01),
    );

    // Get current visible people from state
    List<UserProfile> currentVisiblePeople = <UserProfile>[];
    if (state is MapReady) {
      currentVisiblePeople = (state as MapReady).visiblePeople;
    } else if (state is MapProfileSelected) {
      currentVisiblePeople = (state as MapProfileSelected).visiblePeople;
    }

    try {
      // First, try to join the session
      log.i('🔗 Attempting to join session for user: ${event.selectedUser.displayName}');
      // For now, we'll use the user's ID as the session ID
      // In a real implementation, you'd need to get the actual session ID
      final int sessionId = event.selectedUser.id;
      
      // We need to access the session repository here
      // For now, we'll just print the attempt
      log.i('📡 Would call session join API for session ID: $sessionId');
      
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
        visiblePeople: currentVisiblePeople,
        zoom: 12,
        selectedUser: enriched,
      ));
    } on NoConnectionException {
      emit(MapError('No internet connection'));
    } catch (e) {
      log.e('❌ Error joining session: $e');
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
        visiblePeople: currentVisiblePeople,
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
