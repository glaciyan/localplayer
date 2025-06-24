import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';

abstract class ISpotifyRepository {
  Future<SpotifyArtistData> fetchArtistData(final String spotifyId);
}