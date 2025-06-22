import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import 'package:localplayer/features/match/domain/repositories/match_repository.dart';

class FakeMatchRepository implements MatchRepository {
  final List<UserProfile> _fakeProfiles = const [
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

  final List<UserProfile> _liked = [];
  final List<UserProfile> _disliked = [];

  @override
  Future<List<UserProfile>> fetchProfiles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _fakeProfiles;
  }

  @override
  Future<void> like(UserProfile user) async {
    _liked.add(user);
    print('Liked: ${user.displayName}');
  }

  @override
  Future<void> dislike(UserProfile user) async {
    _disliked.add(user);
    print('Disliked: ${user.displayName}');
  }
}
