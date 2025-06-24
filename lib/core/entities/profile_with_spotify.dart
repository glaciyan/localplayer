import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';


class ProfileWithSpotify {
  final UserProfile user;
  final SpotifyArtistData artist;

  const ProfileWithSpotify({
    required this.user,
    required this.artist,
  });
}
