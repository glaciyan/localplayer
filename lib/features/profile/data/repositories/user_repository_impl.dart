import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import 'package:localplayer/features/profile/domain/repositories/i_user_repository.dart';


// class UserRepositoryImpl implements IUserRepository {
//   final Dio dio;

//   UserRepositoryImpl(this.dio);

//   @override
//   Future<UserProfile> getCurrentUserProfile() async {
//     final response = await dio.get('/profile/me');

//     if (response.statusCode == 200) {
//       return UserProfile.fromJson(response.data);
//     } else {
//       throw Exception('Failed to load user profile');
//     }
//   }


//   @override
//   Future<void> updateUserProfile(UserProfile profile) async {
//     final body = {
//       "description": profile.biography,
//       "avatarLink": profile.avatarLink,
//       "backgroundLink": profile.backgroundLink,
//       "location": profile.location,
//     };

//     final response = await dio.patch('/profile/me', data: body);

//     if (response.statusCode != 200) {
//       throw Exception('Failed to update profile');
//     }
//   }

// }

class FakeUserRepository implements IUserRepository {
  UserProfile mock = const UserProfile(
    handle: '@cgmar',
    displayName: 'Tanaka',
    biography: 'I love Flutter and beats.',
    avatarLink: 'https://placekitten.com/300/300',
    backgroundLink: '',
    location: 'Tokyo, Japan',
    spotifyId: "6OXkkVozDhZ1Ho7yPe4W07",
    position: LatLng(35.6895, 139.6917),
    color: Colors.orange,
    listeners: 1200000,
  );

  final List<UserProfile> fakeProfiles = const [
    UserProfile(
      handle: '@cgmar',
      displayName: 'Tanaka',
      biography: 'I love Flutter and beats.',
      avatarLink: 'https://placekitten.com/300/300',
      backgroundLink: '',
      location: 'Tokyo, Japan',
      spotifyId: "6OXkkVozDhZ1Ho7yPe4W07",
      position: LatLng(35.6895, 139.6917),
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
      position: LatLng(35.0116, 135.7681),
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
      position: LatLng(37.5665, 126.9780),
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
      position: LatLng(52.5200, 13.4050),
      color: Colors.blue,
      listeners: 950000,
    ),
  ];

  @override
  Future<UserProfile> getCurrentUserProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return mock;
  }

  @override
  Future<void> updateUserProfile(final UserProfile profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    mock = profile;
  }

  @override
  Future<List<UserProfile>> getDiscoverableUsers() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return fakeProfiles;
  }
}

