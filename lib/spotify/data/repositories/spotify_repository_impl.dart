import 'package:localplayer/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/spotify/domain/repositories/spotify_repository.dart';

class SpotifyRepositoryImpl implements ISpotifyRepository {
  final SpotifyApiService api;

  SpotifyRepositoryImpl(this.api);

  @override
  Future<SpotifyArtistData> fetchArtistData(String artistId) async {
    final artist = await api.getArtist(artistId);
    final allTracks = await api.getArtistTopTracks(artistId);

    final topTracks = allTracks.take(3).toList();

    return SpotifyArtistData(
      name: artist['name'] ?? '',
      genres: (artist['genres'] as List?)?.join(', ') ?? '',
      imageUrl: artist['images']?[0]['url'] ?? '',
      biography: 'Spotify artist with genre: ${(artist['genres'] as List?)?.join(', ') ?? 'Unknown'}',
      tracks: topTracks,
    );
  }
}
