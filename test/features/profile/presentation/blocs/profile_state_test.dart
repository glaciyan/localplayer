import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_state.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';

void main() {
  group('ProfileState', () {
    test('ProfileLoading should be instance of ProfileLoading', () {
      // Arrange & Act
      final ProfileLoading state = ProfileLoading();

      // Assert
      expect(state, isA<ProfileLoading>());
    });

    test('ProfileLoaded should have correct properties', () {
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
      const bool updated = false;

      // Act
      final ProfileLoaded state = ProfileLoaded(profileWithSpotify, updated);

      // Assert
      expect(state.profile, equals(profileWithSpotify));
      expect(state.updated, equals(updated));
    });

    test('ProfileLoaded should work with updated = true', () {
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
      const bool updated = true;

      // Act
      final ProfileLoaded state = ProfileLoaded(profileWithSpotify, updated);

      // Assert
      expect(state.profile, equals(profileWithSpotify));
      expect(state.updated, equals(updated));
    });

    test('ProfileSignedOut should be instance of ProfileSignedOut', () {
      // Arrange & Act
      final ProfileSignedOut state = ProfileSignedOut();

      // Assert
      expect(state, isA<ProfileSignedOut>());
    });

    test('ProfileError should have correct message', () {
      // Arrange
      const String message = 'Test error message';

      // Act
      final ProfileError state = ProfileError(message);

      // Assert
      expect(state.message, equals(message));
    });

    test('ProfileUpdateSuccess should be instance of ProfileUpdateSuccess', () {
      // Arrange & Act
      final ProfileUpdateSuccess state = ProfileUpdateSuccess();

      // Assert
      expect(state, isA<ProfileUpdateSuccess>());
    });
  });
}
