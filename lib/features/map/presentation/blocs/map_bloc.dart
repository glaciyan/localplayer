import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/map/domain/repositories/i_map_repository.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import 'package:localplayer/spotify/domain/repositories/spotify_repository.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'package:flutter/material.dart';



class MapBloc extends Bloc<MapEvent, MapState> {
  final IMapRepository mapRepository;
  final ISpotifyRepository spotifyRepository;

  List<ProfileWithSpotify> _allProfiles = [];

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

  Future<void> _onLoadMapProfiles(LoadMapProfiles event, Emitter<MapState> emit) async {
    emit(MapLoading());

    try {
      _allProfiles = await mapRepository.fetchProfiles();

      add(InitializeMap()); // Continue with map setup
    } catch (e) {
      emit(MapError("Failed to load map profiles: $e"));
    }
  }

  void _onInitializeMap(InitializeMap event, Emitter<MapState> emit) {
    const double initLatitude = 37.7749;
    const double initLongitude = -122.4194;
    const double initZoom = 12;

    final bounds = flutter_map.LatLngBounds(
      LatLng(initLatitude - 0.01, initLongitude - 0.01),
      LatLng(initLatitude + 0.01, initLongitude + 0.01),
    );

    final visible = _allProfiles.where((p) => bounds.contains(p.user.position)).toList();

    emit(MapReady(
      latitude: initLatitude,
      longitude: initLongitude,
      visiblePeople: visible,
      visibleBounds: bounds,
      zoom: initZoom,
    ));
  }

  void _onUpdateCameraPosition(UpdateCameraPosition event, Emitter<MapState> emit) {
    final visible = _allProfiles.where((p) => event.visibleBounds.contains(p.user.position)).toList();

    emit(MapReady(
      latitude: event.latitude,
      longitude: event.longitude,
      visiblePeople: visible,
      visibleBounds: event.visibleBounds,
      zoom: event.zoom,
    ));
  }

  Future<void> _onSelectPlayer(SelectPlayer event, Emitter<MapState> emit) async {
    final pos = event.selectedUser.position;
    final bounds = flutter_map.LatLngBounds(
      LatLng(pos.latitude - 0.01, pos.longitude - 0.01),
      LatLng(pos.latitude + 0.01, pos.longitude + 0.01),
    );

    try {
      final artistData = await spotifyRepository.fetchArtistData(event.selectedUser.spotifyId);
      final selected = ProfileWithSpotify(user: event.selectedUser, artist: artistData);

      emit(MapProfileSelected(
        latitude: pos.latitude,
        longitude: pos.longitude,
        visibleBounds: bounds,
        visiblePeople: _allProfiles,
        zoom: 12,
        selectedUser: selected,
      ));
    } catch (e) {
      emit(MapError("Failed to load Spotify data: $e"));
    }
  }

  void _onDeselectPlayer(DeselectPlayer event, Emitter<MapState> emit) {
    final pos = event.selectedUser.position;
    final bounds = flutter_map.LatLngBounds(
      LatLng(pos.latitude - 0.01, pos.longitude - 0.01),
      LatLng(pos.latitude + 0.01, pos.longitude + 0.01),
    );

    final visible = _allProfiles.where((p) => bounds.contains(p.user.position)).toList();

    emit(MapReady(
      latitude: pos.latitude,
      longitude: pos.longitude,
      visiblePeople: visible,
      visibleBounds: bounds,
      zoom: 12,
    ));
  }

  Future<void> _onRequestJoinSession(RequestJoinSession event, Emitter<MapState> emit) async {
    final pos = event.selectedUser.position;
    final bounds = flutter_map.LatLngBounds(
      LatLng(pos.latitude - 0.01, pos.longitude - 0.01),
      LatLng(pos.latitude + 0.01, pos.longitude + 0.01),
    );

    try {
      final artistData = await spotifyRepository.fetchArtistData(event.selectedUser.spotifyId);
      final enriched = ProfileWithSpotify(user: event.selectedUser, artist: artistData);

      emit(MapProfileSelected(
        latitude: pos.latitude,
        longitude: pos.longitude,
        visibleBounds: bounds,
        visiblePeople: _allProfiles,
        zoom: 12,
        selectedUser: enriched,
      ));
    } catch (e) {
      emit(MapError("Failed to reload Spotify data: $e"));
    }
  }
}
