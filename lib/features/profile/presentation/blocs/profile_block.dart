import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/profile/domain/repositories/i_user_repository.dart';
import 'package:localplayer/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/spotify/domain/entities/spotify_artist_data.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IUserRepository userRepository;
  final SpotifyApiService spotifyService;

  ProfileBloc(this.userRepository, this.spotifyService) : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
  try {
    final user = await userRepository.getCurrentUserProfile();
    final artist = await spotifyService.getArtist(user.spotifyId);
    final tracks = await spotifyService.getArtistTopTracks(user.spotifyId);

    final artistData = SpotifyArtistData(
      name: artist['name'] ?? '',
      genres: (artist['genres'] as List?)?.join(', ') ?? '',
      imageUrl: artist['images']?[0]['url'] ?? '',
      biography: 'Spotify artist with genre: ${(artist['genres'] as List?)?.join(', ') ?? 'Unknown'}',
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

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    try {
      await userRepository.updateUserProfile(event.updatedProfile.user);

      final artistJson = await spotifyService.getArtist(event.updatedProfile.user.spotifyId);
      final tracks = await spotifyService.getArtistTopTracks(event.updatedProfile.user.spotifyId);

      final artistData = SpotifyArtistData(
        name: artistJson['name'] ?? '',
        genres: (artistJson['genres'] as List?)?.join(', ') ?? '',
        imageUrl: artistJson['images']?[0]['url'] ?? '',
        biography: 'Spotify artist with genre: ${(artistJson['genres'] as List?)?.join(', ') ?? 'Unknown'}',
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
