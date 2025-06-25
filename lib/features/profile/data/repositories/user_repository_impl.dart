//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:localplayer/features/profile/domain/repositories/i_user_repository.dart';

class UserRepositoryImpl implements IUserRepository {
  final ProfileRemoteDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<UserProfile> getCurrentUserProfile() async =>
      await dataSource.fetchCurrentUserProfile();

  @override
  Future<void> updateUserProfile(final UserProfile profile) async =>
      dataSource.updateUserProfile(profile);

  @override
  Future<List<UserProfile>> getDiscoverableUsers() async => <UserProfile>[];
}

class FakeUserRepository implements IUserRepository {
  UserProfile mock = const UserProfile(
    id: 1,
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

  final List<UserProfile> fakeProfiles = const <UserProfile>[
    UserProfile(
      id: 2,
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
      id: 3,
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
      id: 4,
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
      id: 5,
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
