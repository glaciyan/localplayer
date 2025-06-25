import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/features/match/data/datasources/match_remote_data_source.dart';
import 'package:localplayer/features/match/data/match_repository_interface.dart';


class MatchRepository implements IMatchRepository {
  final ISpotifyRepository spotifyRepository;
  final MatchRemoteDataSource matchRemoteDataSource;
  const MatchRepository(this.spotifyRepository, this.matchRemoteDataSource);

  @override
  Future<List<ProfileWithSpotify>> fetchProfilesWithSpotify(final double latitude, final double longitude, final double radiusKm) async {
    final Map<String, dynamic> rawData = await matchRemoteDataSource.fetchProfiles(latitude, longitude, radiusKm);    
    final List<dynamic> profilesList = rawData['profiles'] as List<dynamic>? ?? <dynamic>[];
    
    final List<UserProfile> profilesInRadius = <UserProfile> [];
    for (final dynamic entry in profilesList) {
      try {
        final UserProfile user = UserProfile.fromJson(entry as Map<String, dynamic>);
        profilesInRadius.add(user);
      } catch (e) {
      }
    }
    
    if (profilesInRadius.isEmpty) {
      return <ProfileWithSpotify>[];
    }

    final List<ProfileWithSpotify> enriched = await Future.wait(
      profilesInRadius.map((final UserProfile user) async {
        try {
          final SpotifyArtistData artist = await spotifyRepository.fetchArtistData(user.spotifyId);
          return ProfileWithSpotify(user: user, artist: artist);
        } catch (e) {
          return ProfileWithSpotify(
            user: user,
            artist: SpotifyArtistData(
              name: user.displayName,
              genres: 'Unknown',
              imageUrl: user.avatarLink,
              biography: user.biography,
              tracks: <TrackEntity> [], 
            ),
          );
        }
      }),
    );

    final List<ProfileWithSpotify> filteredEnriched = enriched.where((final ProfileWithSpotify profile) => profile.artist.genres != 'Unknown').toList();
    return filteredEnriched;
  }

  @override
  Future<Map<String, dynamic>> like(final String profileId) async => await matchRemoteDataSource.like(profileId);

  @override
  Future<Map<String, dynamic>> dislike(final String profileId) async => await matchRemoteDataSource.dislike(profileId);
}
