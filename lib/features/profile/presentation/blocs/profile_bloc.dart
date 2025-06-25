import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/services/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/features/profile/domain/repositories/i_user_repository.dart';


import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IUserRepository userRepository;
  final SpotifyApiService spotifyService;

  ProfileBloc(this.userRepository, this.spotifyService) : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    final LoadProfile event,
    final Emitter<ProfileState> emit,
  ) async {
    try {
      final UserProfile user = await userRepository.getCurrentUserProfile();

      SpotifyArtistData artistData;

      if (user.spotifyId.isNotEmpty) {
        try {
          final Map<String, dynamic> artist =
              await spotifyService.getArtist(user.spotifyId);
          final List<TrackEntity> tracks =
              await spotifyService.getArtistTopTracks(user.spotifyId);

          artistData = SpotifyArtistData(
            name: artist['name']?.toString() ?? user.displayName,
            genres: (artist['genres'] as List<dynamic>?)
                    ?.map((final dynamic e) => e.toString())
                    .join(', ') ??
                'Unknown',
            imageUrl: ((artist['images'] as List<dynamic>?)?[0]
                        as Map<String, dynamic>?)?['url']?.toString() ??
                    user.avatarLink,
            biography:
                'Spotify artist with genre: ${(artist['genres'] as List<dynamic>?)?.map((final dynamic e) => e.toString()).join(', ') ?? 'Unknown'}',
            tracks: tracks,
            popularity: (artist['popularity'] as num?)?.toInt() ?? 0,
            listeners: (artist['followers'] as num?)?.toInt() ?? 0,
          );
        } catch (_) {
          artistData = SpotifyArtistData(
            name: user.displayName,
            genres: 'Unknown',
            imageUrl: user.avatarLink,
            biography: user.biography,
            tracks: <TrackEntity>[],
            popularity: 0,
            listeners: 0,
          );
        }
      } else {
        artistData = SpotifyArtistData(
          name: user.displayName,
          genres: 'Unknown',
          imageUrl: user.avatarLink,
          biography: user.biography,
          tracks: <TrackEntity>[],
          popularity: 0,
          listeners: 0,
        );
      }

      emit(
        ProfileLoaded(
          ProfileWithSpotify(user: user, artist: artistData),
        ),
      );
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  Future<void> _onUpdateProfile(
    final UpdateProfile event,
    final Emitter<ProfileState> emit,
  ) async {
    try {
      await userRepository.updateUserProfile(event.updatedProfile.user);

      final UserProfile updated = event.updatedProfile.user;
      SpotifyArtistData artistData;

      if (updated.spotifyId.isNotEmpty) {
        try {
          final Map<String, dynamic> artistJson =
              await spotifyService.getArtist(updated.spotifyId);
          final List<TrackEntity> tracks =
              await spotifyService.getArtistTopTracks(updated.spotifyId);

          artistData = SpotifyArtistData(
            name: artistJson['name']?.toString() ?? updated.displayName,
            genres: (artistJson['genres'] as List<dynamic>?)
                    ?.map((final dynamic e) => e.toString())
                    .join(', ') ??
                'Unknown',
            imageUrl: ((artistJson['images'] as List<dynamic>?)?[0]
                        as Map<String, dynamic>?)?['url']?.toString() ??
                    updated.avatarLink,
            biography:
                'Spotify artist with genre: ${(artistJson['genres'] as List<dynamic>?)?.map((final dynamic e) => e.toString()).join(', ') ?? 'Unknown'}',
            tracks: tracks,
            popularity: (artistJson['popularity'] as num?)?.toInt() ?? 0,
            listeners: (artistJson['followers'] as num?)?.toInt() ?? 0,
          );
        } catch (_) {
          artistData = SpotifyArtistData(
            name: updated.displayName,
            genres: 'Unknown',
            imageUrl: updated.avatarLink,
            biography: updated.biography,
            tracks: <TrackEntity>[],
            popularity: 0,
            listeners: 0,
          );
        }
      } else {
        artistData = SpotifyArtistData(
          name: updated.displayName,
          genres: 'Unknown',
          imageUrl: updated.avatarLink,
          biography: updated.biography,
          tracks: <TrackEntity>[],
          popularity: 0,
          listeners: 0,
        );
      }

      emit(
        ProfileLoaded(
          ProfileWithSpotify(user: updated, artist: artistData),
        ),
      );
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }
}
