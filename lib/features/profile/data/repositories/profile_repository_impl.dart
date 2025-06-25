//import 'package:dio/dio.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:localplayer/features/profile/data/profile_repository_interface.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteDataSource dataSource;
  final ISpotifyRepository spotifyRepository;

  ProfileRepositoryImpl(this.dataSource, this.spotifyRepository);

  @override
  Future<ProfileWithSpotify> fetchCurrentUserEnrichedProfile() async {
    final UserProfile user = await dataSource.fetchCurrentUserProfile();

    try {
      if (user.spotifyId.isNotEmpty) {
        final SpotifyArtistData artist = await spotifyRepository.fetchArtistData(user.spotifyId);
        return ProfileWithSpotify(user: user, artist: artist);
      } else {
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
  Future<void> updateUserProfile(final ProfileWithSpotify profile) async {
    dataSource.updateUserProfile(profile.user.displayName, profile.user.biography, profile.user.spotifyId);
  }
      

  @override
  Future<void> signOut() async => dataSource.signOut();
} 
