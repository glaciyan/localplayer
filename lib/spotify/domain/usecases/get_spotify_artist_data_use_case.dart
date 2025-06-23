import 'package:localplayer/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/spotify/domain/repositories/spotify_repository.dart';

class GetSpotifyArtistDataUseCase {
  final ISpotifyRepository repository;

  GetSpotifyArtistDataUseCase(this.repository);

  Future<SpotifyArtistData> call(final String artistId) => repository.fetchArtistData(artistId);
}