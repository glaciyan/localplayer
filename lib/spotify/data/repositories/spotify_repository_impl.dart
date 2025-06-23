import 'package:localplayer/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/spotify/domain/repositories/spotify_repository.dart';

class SpotifyRepositoryImpl implements ISpotifyRepository {
  final SpotifyApiService api;

  SpotifyRepositoryImpl(this.api);

  @override
  Future<SpotifyArtistData> fetchArtistData(final String artistId) async {
    final Map<String, dynamic> artist = await api.getArtist(artistId);
    final List<TrackEntity> allTracks = await api.getArtistTopTracks(artistId);

    final List<TrackEntity> topTracks = allTracks.take(3).toList();

    return SpotifyArtistData(
      name: artist['name'] ?? '',
      genres: (artist['genres'] as List<dynamic>?)?.join(', ') ?? '',
      imageUrl: artist['images']?[0]['url'] ?? '',
      biography: 'Spotify artist with genre: ${(artist['genres'] as List<dynamic>?)?.join(', ') ?? 'Unknown'}',
      tracks: topTracks,
    );
  }
}
