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
import 'package:localplayer/features/session/domain/interfaces/session_controller_interface.dart';
import 'package:localplayer/main.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'dart:async';
import 'package:localplayer/features/map/utils/marker_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final IMapRepository mapRepository;
  final ISpotifyRepository spotifyRepository;
  final ISessionController sessionController;

  List<UserProfile> _allProfiles = <UserProfile> [];
  Timer? _debounceTimer;

  MapBloc({
    required this.mapRepository,
    required this.spotifyRepository,
    required this.sessionController,
  }) : super(MapInitial()) {
    on<LoadMapProfiles>(_onLoadMapProfiles);
    on<UpdateCameraPosition>(_onUpdateCameraPosition);
    on<SelectPlayer>(_onSelectPlayer);
    on<DeselectPlayer>(_onDeselectPlayer);
    on<RequestJoinSession>(_onRequestJoinSession);
    on<LeaveSession>(_onLeaveSession);
  }


  Future<void> _onLoadMapProfiles(final LoadMapProfiles event, final Emitter<MapState> emit) async {
    emit(MapLoading());
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final double? userLat = prefs.getDouble('user_latitude');
    final double? userLng = prefs.getDouble('user_longitude');
    
    final double initLatitude = userLat ?? 47.6596;
    final double initLongitude = userLng ?? 9.1753;

    const double initZoom = 12;
    
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
    final UserProfile me = await mapRepository.fetchMe();
    try {
      final List<UserProfile> profilesInRadius =
          await mapRepository.fetchProfiles(
        event.latitude,
        event.longitude,
        radius,
      );

      emit(MapReady(  
        me: me,
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
    final UserProfile me = await mapRepository.fetchMe();

    final LatLng pos = event.selectedUser.position;
    final flutter_map.LatLngBounds bounds = flutter_map.LatLngBounds(
      LatLng(pos.latitude - 0.01, pos.longitude - 0.01),
      LatLng(pos.latitude + 0.01, pos.longitude + 0.01),
    );

    try {
      emit(MapProfileSelected(
        me: me,
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
        me: me,
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
    final UserProfile me = await mapRepository.fetchMe();
    try {
      final List<UserProfile> profilesInRadius = await mapRepository.fetchProfiles(
        event.latitude,
        event.longitude,
        radius,
      );

      emit(MapReady(
        me: me,
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
    // Get current state info
    List<UserProfile> currentVisiblePeople = <UserProfile>[];
    if (state is MapReady) {
      currentVisiblePeople = (state as MapReady).visiblePeople;
    } else if (state is MapProfileSelected) {
      currentVisiblePeople = (state as MapProfileSelected).visiblePeople;
    }

    final LatLng pos = event.selectedUser.position;
    final flutter_map.LatLngBounds bounds = flutter_map.LatLngBounds(
      LatLng(pos.latitude - 0.01, pos.longitude - 0.01),
      LatLng(pos.latitude + 0.01, pos.longitude + 0.01),
    );

    try {
      // Then, try to join the session
      log.i('🔗 Requesting to join session for user: ${event.selectedUser.displayName}');
      final int? sessionId = event.selectedUser.sessionId;
      if (sessionId != null) {
        log.i('Attempting to join session: $sessionId');
        sessionController.joinSession(sessionId);
        
        // Add a small delay to allow backend to update the user's participating field
        await Future.delayed(const Duration(milliseconds: 1000));
      } else {
        log.w('No session available');
        return;
      }
      
      // Refresh current user profile to get updated participating status
      final UserProfile updatedMe = await mapRepository.fetchMe();
      
      final SpotifyArtistData artistData = await spotifyRepository.fetchArtistData(
        event.selectedUser.spotifyId,
      );
      
      final ProfileWithSpotify enriched = ProfileWithSpotify(
        user: event.selectedUser,
        artist: artistData,
      );

      emit(MapProfileSelected(
        me: updatedMe,  // Use updated user profile
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
      final UserProfile me = await mapRepository.fetchMe();  // Add this line
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
        me: me,
        latitude: pos.latitude,
        longitude: pos.longitude,
        visibleBounds: bounds,
        visiblePeople: currentVisiblePeople,
        zoom: 12,
        selectedUser: enriched,
      ));
    }
  }

  Future<void> _onLeaveSession(
    final LeaveSession event,
    final Emitter<MapState> emit,
  ) async {
    // Get current state info
    List<UserProfile> currentVisiblePeople = <UserProfile>[];
    if (state is MapReady) {
      currentVisiblePeople = (state as MapReady).visiblePeople;
    } else if (state is MapProfileSelected) {
      currentVisiblePeople = (state as MapProfileSelected).visiblePeople;
    }

    try {
      log.i('🚪 Leaving current session from map');
      sessionController.leaveSession();
      log.i('✅ Successfully left session from map');
      
      // Add delay to allow backend to update the user's participating field
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Refresh current user profile to get updated participating status
      final UserProfile updatedMe = await mapRepository.fetchMe();
      
      // Return to the current map state with updated user profile
      if (state is MapProfileSelected) {
        final MapProfileSelected currentState = state as MapProfileSelected;
        emit(MapProfileSelected(
          me: updatedMe,  // Use updated user profile
          latitude: currentState.latitude,
          longitude: currentState.longitude,
          visibleBounds: currentState.visibleBounds,
          visiblePeople: currentVisiblePeople,
          zoom: currentState.zoom,
          selectedUser: currentState.selectedUser,
        ));
      } else {
        // If not in a profile selected state, just emit the current state with updated me
        if (state is MapReady) {
          final MapReady currentState = state as MapReady;
          emit(MapReady(
            me: updatedMe,  // Use updated user profile
            latitude: currentState.latitude,
            longitude: currentState.longitude,
            visiblePeople: currentState.visiblePeople,
            visibleBounds: currentState.visibleBounds,
            zoom: currentState.zoom,
          ));
        } else {
          emit(state);
        }
      }
    } catch (e) {
      log.e('❌ Error leaving session from map: $e');
      emit(MapError('Failed to leave session: $e'));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
