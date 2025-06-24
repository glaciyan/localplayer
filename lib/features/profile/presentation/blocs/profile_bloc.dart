import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import 'package:localplayer/features/profile/domain/repositories/i_user_repository.dart';
import 'package:localplayer/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/spotify/domain/entities/track_entity.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IUserRepository userRepository;
  final SpotifyApiService spotifyService;

  ProfileBloc(this.userRepository, this.spotifyService) : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(final LoadProfile event, final Emitter<ProfileState> emit) async {
  try {
    final UserProfile user = await userRepository.getCurrentUserProfile();
    final Map<String, dynamic> artist = await spotifyService.getArtist(user.spotifyId);
    final List<TrackEntity> tracks = await spotifyService.getArtistTopTracks(user.spotifyId);

    final SpotifyArtistData artistData = SpotifyArtistData(
      name: artist['name']?.toString() ?? '',
      genres: (artist['genres'] as List<dynamic>?)?.map((final dynamic e) => e.toString()).join(', ') ?? '',
      imageUrl: ((artist['images'] as List<dynamic>?)?[0] as Map<String, dynamic>?)?['url']?.toString() ?? '',
      biography: 'Spotify artist with genre: ${(artist['genres'] as List<dynamic>?)?.map((final dynamic e) => e.toString()).join(', ') ?? 'Unknown'}',
      tracks: tracks,
    );

    emit(ProfileLoaded(ProfileWithSpotify(
      user: user,
      artist: artistData,
    )));
  } catch (e) {
    emit(ProfileError('Failed to load profile: $e'));
  }
}

  Future<void> _onUpdateProfile(final UpdateProfile event, final Emitter<ProfileState> emit) async {
    try {
      await userRepository.updateUserProfile(event.updatedProfile.user);

      final Map<String, dynamic> artistJson = await spotifyService.getArtist(event.updatedProfile.user.spotifyId);
      final List<TrackEntity> tracks = await spotifyService.getArtistTopTracks(event.updatedProfile.user.spotifyId);

      final SpotifyArtistData artistData = SpotifyArtistData(
        name: artistJson['name']?.toString() ?? '',
        genres: (artistJson['genres'] as List<dynamic>?)?.map((final dynamic e) => e.toString()).join(', ') ?? '',
        imageUrl: ((artistJson['images'] as List<dynamic>?)?[0] as Map<String, dynamic>?)?['url']?.toString() ?? '',
        biography: 'Spotify artist with genre: ${(artistJson['genres'] as List<dynamic>?)?.map((final dynamic e) => e.toString()).join(', ') ?? 'Unknown'}',
        tracks: tracks,
      );

      emit(ProfileLoaded(ProfileWithSpotify(
        user: event.updatedProfile.user,
        artist: artistData,
      )));
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }
}
