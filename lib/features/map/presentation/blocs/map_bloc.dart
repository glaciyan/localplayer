import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/features/map/data/map_repository_interface.dart';
import 'package:localplayer/core/network/no_connection_exception.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'dart:async';
import 'package:localplayer/features/map/utils/marker_utils.dart';


class MapBloc extends Bloc<MapEvent, MapState> {
  final IMapRepository mapRepository;
  final ISpotifyRepository spotifyRepository;

  List<ProfileWithSpotify> _allProfiles = <ProfileWithSpotify> [];
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
      _allProfiles = await mapRepository.fetchProfilesWithSpotify(0, 0, 1000000);
      add(InitializeMap());
    } on NoConnectionException {
      emit(MapError('No internet connection'));
    } catch (e) {
      emit(MapError("Failed to load map profiles: $e"));
    }
  }

  void _onInitializeMap(final InitializeMap event, final Emitter<MapState> emit) {
    const double initLatitude = 37.7749;
    const double initLongitude = -122.4194;
    const double initZoom = 12;

    final flutter_map.LatLngBounds bounds = flutter_map.LatLngBounds(
      LatLng(initLatitude - 0.01, initLongitude - 0.01),
      LatLng(initLatitude + 0.01, initLongitude + 0.01),
    );

    final List<ProfileWithSpotify> visible = _allProfiles
        .where(
          (final ProfileWithSpotify profile) =>
              bounds.contains(profile.user.position),
        )
        .toList();

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
      final List<ProfileWithSpotify> profilesInRadius =
          await mapRepository.fetchProfilesWithSpotify(
        event.latitude,
        event.longitude,
        radius,
      );

      final List<ProfileWithSpotify> visible = profilesInRadius
          .where(
            (final ProfileWithSpotify profile) =>
                event.visibleBounds.contains(profile.user.position),
          )
          .toList();

      emit(MapReady(
        latitude: event.latitude,
        longitude: event.longitude,
        visiblePeople: visible,
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
      final SpotifyArtistData artistData =
          await spotifyRepository.fetchArtistData(
        event.selectedUser.spotifyId,
      );
      final ProfileWithSpotify selected = ProfileWithSpotify(
        user: event.selectedUser,
        artist: artistData,
      );

      emit(MapProfileSelected(
        latitude: pos.latitude,
        longitude: pos.longitude,
        visibleBounds: bounds,
        visiblePeople: _allProfiles,
        zoom: 12,
        selectedUser: selected,
      ));
    } on NoConnectionException {
      emit(MapError('No internet connection'));
    } catch (_) {
      final ProfileWithSpotify selected = ProfileWithSpotify(
        user: event.selectedUser,
        artist: SpotifyArtistData(
          name: event.selectedUser.displayName,
          genres: 'Unknown',
          imageUrl: event.selectedUser.avatarLink,
          biography: event.selectedUser.biography,
          tracks: <TrackEntity>[],
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
    final LatLng pos = event.selectedUser.position;
    final flutter_map.LatLngBounds bounds = flutter_map.LatLngBounds(
      LatLng(pos.latitude - 0.01, pos.longitude - 0.01),
      LatLng(pos.latitude + 0.01, pos.longitude + 0.01),
    );

    final List<ProfileWithSpotify> visible = _allProfiles
        .where(
          (final ProfileWithSpotify profile) =>
              bounds.contains(profile.user.position),
        )
        .toList();

    emit(MapReady(
      latitude: pos.latitude,
      longitude: pos.longitude,
      visiblePeople: visible,
      visibleBounds: bounds,
      zoom: 12,
    ));
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
