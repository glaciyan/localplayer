import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:localplayer/features/match/presentation/blocs/match_state.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';

void main() {
  group('MatchState', () {
    test('MatchInitial should be instance of MatchInitial', () {
      // Arrange & Act
      final MatchInitial state = MatchInitial();

      // Assert
      expect(state, isA<MatchInitial>());
    });

    test('MatchLoading should be instance of MatchLoading', () {
      // Arrange & Act
      final MatchLoading state = MatchLoading();

      // Assert
      expect(state, isA<MatchLoading>());
    });

    test('MatchError should have correct message', () {
      // Arrange
      const String message = 'Test error message';

      // Act
      final MatchError state = MatchError(message);

      // Assert
      expect(state.message, equals(message));
    });

    test('ToastedMatchError should have correct message', () {
      // Arrange
      const String message = 'Test toasted error message';

      // Act
      final ToastedMatchError state = ToastedMatchError(message);

      // Assert
      expect(state.message, equals(message));
    });

    test('MatchLoaded should have correct properties', () {
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
      final List<ProfileWithSpotify> profiles = <ProfileWithSpotify>[profileWithSpotify];
      const int currentIndex = 0;

      // Act
      final MatchLoaded state = MatchLoaded(profiles, currentIndex: currentIndex);

      // Assert
      expect(state.profiles, equals(profiles));
      expect(state.currentIndex, equals(currentIndex));
      expect(state.currentProfile, equals(profileWithSpotify));
      expect(state.hasMore, equals(false));
    });

    test('MatchLoaded copyWith should work correctly', () {
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
      final List<ProfileWithSpotify> profiles = <ProfileWithSpotify>[profileWithSpotify, profileWithSpotify];
      const int currentIndex = 0;

      final MatchLoaded state = MatchLoaded(profiles, currentIndex: currentIndex);

      // Act
      final MatchLoaded newState = state.copyWith(currentIndex: 1);

      // Assert
      expect(newState.profiles, equals(profiles));
      expect(newState.currentIndex, equals(1));
      expect(newState.currentProfile, equals(profileWithSpotify));
    });

    test('MatchLoaded hasMore should work correctly', () {
      // Arrange
      final UserProfile userProfile1 = UserProfile(
        id: 1,
        handle: 'testuser1',
        displayName: 'Test User 1',
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
      final UserProfile userProfile2 = UserProfile(
        id: 2,
        handle: 'testuser2',
        displayName: 'Test User 2',
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
      final ProfileWithSpotify profileWithSpotify1 = ProfileWithSpotify(
        user: userProfile1,
        artist: SpotifyArtistData(
          name: 'Test Artist 1',
          genres: 'pop, rock',
          imageUrl: 'test_image.jpg',
          biography: 'Test biography',
          tracks: <TrackEntity>[],
          popularity: 50,
          listeners: 1000,
        ),
      );
      final ProfileWithSpotify profileWithSpotify2 = ProfileWithSpotify(
        user: userProfile2,
        artist: SpotifyArtistData(
          name: 'Test Artist 2',
          genres: 'pop, rock',
          imageUrl: 'test_image.jpg',
          biography: 'Test biography',
          tracks: <TrackEntity>[],
          popularity: 50,
          listeners: 1000,
        ),
      );
      final List<ProfileWithSpotify> profiles = <ProfileWithSpotify>[profileWithSpotify1, profileWithSpotify2];

      // Act
      final MatchLoaded state = MatchLoaded(profiles, currentIndex: 0);

      // Assert
      expect(state.hasMore, equals(true));
    });
  });
}
