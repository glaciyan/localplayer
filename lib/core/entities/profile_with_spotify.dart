import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import 'package:localplayer/spotify/domain/entities/spotify_artist_data.dart';


class ProfileWithSpotify {
  final UserProfile user;
  final SpotifyArtistData artist;

  const ProfileWithSpotify({
    required this.user,
    required this.artist,
  });
}
