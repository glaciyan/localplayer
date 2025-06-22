import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/map/domain/repositories/i_map_repository.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import 'package:localplayer/spotify/domain/repositories/spotify_repository.dart';

class MapRepository implements IMapRepository {
  final ISpotifyRepository spotifyRepository;

  const MapRepository(this.spotifyRepository);

  @override
  Future<List<ProfileWithSpotify>> fetchProfiles() async {
    final List<UserProfile> rawProfiles = _fakeProfiles;

    final enriched = await Future.wait(
      rawProfiles.map((user) async {
        final artist = await spotifyRepository.fetchArtistData(user.spotifyId);
        return ProfileWithSpotify(user: user, artist: artist);
      }),
    );

    return enriched;
  }
  static const List<UserProfile> _fakeProfiles = [
    UserProfile(
      handle: '@cgmar',
      displayName: 'Tanaka',
      biography: 'I love Flutter and beats.',
      avatarLink: 'https://placekitten.com/300/300',
      backgroundLink: '',
      location: 'Tokyo, Japan',
      spotifyId: "6OXkkVozDhZ1Ho7yPe4W07",
      position: LatLng(35.6895, 139.6917), // Tokyo
      color: Colors.orange,
      listeners: 1200000,
    ),
    UserProfile(
      handle: '@miyu',
      displayName: 'Miyu',
      biography: 'Jazz pianist and tea lover.',
      avatarLink: 'https://placekitten.com/301/301',
      backgroundLink: '',
      location: 'Kyoto, Japan',
      spotifyId: "3TVXtAsR1Inumwj472S9r4",
      position: LatLng(35.0116, 135.7681), // Kyoto
      color: Colors.green,
      listeners: 540000,
    ),
    UserProfile(
      handle: '@lee',
      displayName: 'Lee',
      biography: 'Dancing through code.',
      avatarLink: 'https://placekitten.com/302/302',
      backgroundLink: '',
      location: 'Seoul, Korea',
      spotifyId: "5K4W6rqBFWDnAN6FQUkS6x",
      position: LatLng(37.5665, 126.9780), // Seoul
      color: Colors.purple,
      listeners: 800000,
    ),
    UserProfile(
      handle: '@sophia',
      displayName: 'Sophia',
      biography: 'Sings in 4 languages.',
      avatarLink: 'https://placekitten.com/303/303',
      backgroundLink: '',
      location: 'Berlin, Germany',
      spotifyId: "1uNFoZAHBGtllmzznpCI3s",
      position: LatLng(52.5200, 13.4050), // Berlin
      color: Colors.blue,
      listeners: 950000,
    ),
  ];
}
