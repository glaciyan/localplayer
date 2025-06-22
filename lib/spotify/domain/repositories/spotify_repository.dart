import 'package:localplayer/spotify/domain/entities/spotify_artist_data.dart';

abstract class ISpotifyRepository {
  Future<SpotifyArtistData> fetchArtistData(String spotifyId);
}