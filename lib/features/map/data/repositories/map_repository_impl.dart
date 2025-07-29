import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/features/map/data/map_repository_interface.dart';
import 'package:localplayer/features/map/data/datasources/map_remote_data_source.dart';

class MapRepository implements IMapRepository {
  final ISpotifyRepository spotifyRepository;
  final MapRemoteDataSource mapRemoteDataSource;
  const MapRepository(this.spotifyRepository, this.mapRemoteDataSource);

  @override
  Future<ProfileWithSpotify> fetchProfileWithSpotify(final UserProfile user) async {
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
          popularity: 0,
          listeners: 0,
        ),
      );
    }
  }
  @override
  Future<List<ProfileWithSpotify>> fetchProfilesWithSpotify(final double latitude, final double longitude, final double radiusKm) async {
    final Map<String, dynamic> rawData = await mapRemoteDataSource.fetchProfiles(latitude, longitude, radiusKm);    
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
              popularity: 0,
              listeners: 0,
            ),
          );
        }
      }),
    );

    // Filter out profiles that don't have Spotify data
    final List<ProfileWithSpotify> filteredEnriched = enriched.where((final ProfileWithSpotify profile) => 
      profile.user.spotifyId.isNotEmpty
    ).toList();
    return filteredEnriched;
  }

  @override
  Future<List<UserProfile>> fetchProfiles(final double latitude, final double longitude, final double radiusKm) async {
    final Map<String, dynamic> rawData = await mapRemoteDataSource.fetchProfiles(latitude, longitude, radiusKm);    
    final List<dynamic> profilesList = rawData['profiles'] as List<dynamic>? ?? <dynamic>[];
    final List<UserProfile> profilesInRadius = <UserProfile> [];
    for (final dynamic entry in profilesList) {
      try {
        final UserProfile user = UserProfile.fromJson(entry as Map<String, dynamic>);
        profilesInRadius.add(user);
      } catch (e) {
      }
    }
    
    // Filter out profiles that don't have Spotify data
    final List<UserProfile> filteredProfiles = profilesInRadius.where((final UserProfile profile) => 
      profile.spotifyId.isNotEmpty
    ).toList();
    return filteredProfiles;
  }
}
