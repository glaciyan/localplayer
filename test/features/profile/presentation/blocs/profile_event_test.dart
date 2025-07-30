import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';

void main() {
  group('ProfileEvent', () {
    test('LoadProfile should be instance of LoadProfile', () {
      // Arrange & Act
      final LoadProfile event = LoadProfile();

      // Assert
      expect(event, isA<LoadProfile>()); 
    });

    test('LoadProfile should have null updatedProfile', () {
      // Arrange & Act
      final LoadProfile event = LoadProfile();

      // Assert
      expect(event.updatedProfile, isNull);
    });

    test('ProfileUpdated should have correct properties', () {
      // Arrange
      const String displayName = 'Test User';
      const String biography = 'Test biography';

      // Act
      final ProfileUpdated event = ProfileUpdated(displayName: displayName, biography: biography);

      // Assert
      expect(event.displayName, equals(displayName));
      expect(event.biography, equals(biography));
    });

    test('UpdateProfile should have correct updatedProfile', () {
      // Arrange
      final UserProfile userProfile = UserProfile(
        id: 1,
        handle: 'testuser',
        displayName: 'Test User',
        biography: 'Test bio',
        avatarLink: 'test.jpg',
        backgroundLink: '',
        location: '',
        spotifyId: '',
        position: const LatLng(40.7128, -74.0060),
        color: const Color(0xFF0000),
        listeners: 0,
        likes: 0,
        dislikes: 0,
        popularity: 0,
        sessionStatus: null,
        createdAt: null,
        participating: null,
        sessionId: null,
      );
      final ProfileWithSpotify profileWithSpotify = ProfileWithSpotify(
        user: userProfile,
        artist: SpotifyArtistData(
          name: 'Test Artist',
          genres: 'pop, rock',
          imageUrl: 'test_image.jpg',
          biography: 'Test biography',
          tracks: <TrackEntity>[],
          popularity: 50,
          listeners: 1000,
        ),
      );

      // Act
      final UpdateProfile event = UpdateProfile(profileWithSpotify);

      // Assert
      expect(event.updatedProfile, equals(profileWithSpotify));
    });

    test('SignOut should be instance of SignOut', () {
      // Arrange & Act
      final SignOut event = SignOut();

      // Assert
      expect(event, isA<SignOut>());
    });

    test('ProfileUpdateSuccess should be instance of ProfileUpdateSuccess', () {
      // Arrange & Act
      final ProfileUpdateSuccess event = ProfileUpdateSuccess();

      // Assert
      expect(event, isA<ProfileUpdateSuccess>());
    });
  });
}
