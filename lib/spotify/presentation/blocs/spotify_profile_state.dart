import 'package:localplayer/spotify/domain/entities/spotify_artist_data.dart';

class SpotifyProfileState {
  final bool loading;
  final String? error;
  final SpotifyArtistData? artist;

  const SpotifyProfileState({
    required this.loading,
    this.error,
    this.artist,
  });

  factory SpotifyProfileState.initial() => const SpotifyProfileState(loading: false);

  SpotifyProfileState copyWith({
    final bool? loading,
    final String? error,
    final SpotifyArtistData? artist,
  }) => SpotifyProfileState(
      loading: loading ?? this.loading,
      error: error,
      artist: artist ?? this.artist,
    );
}