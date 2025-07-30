import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('ProfileWithSpotify', () {
    test('should create ProfileWithSpotify with required properties', () {
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
      final SpotifyArtistData spotifyArtistData = SpotifyArtistData(
        name: 'Test Artist',
        genres: 'pop, rock',
        imageUrl: 'test_image.jpg',
        biography: 'Test biography',
        tracks: <TrackEntity>[],
        popularity: 50,
        listeners: 1000,
      );

      // Act
      final ProfileWithSpotify profileWithSpotify = ProfileWithSpotify(
        user: userProfile,
        artist: spotifyArtistData,
      );

      // Assert
      expect(profileWithSpotify, isA<ProfileWithSpotify>());
      expect(profileWithSpotify.user, equals(userProfile));
      expect(profileWithSpotify.artist, equals(spotifyArtistData));
    });

    test('should have const constructor', () {
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
      final SpotifyArtistData spotifyArtistData = SpotifyArtistData(
        name: 'Test Artist',
        genres: 'pop, rock',
        imageUrl: 'test_image.jpg',
        biography: 'Test biography',
        tracks: <TrackEntity>[],
        popularity: 50,
        listeners: 1000,
      );

      // Act
      final ProfileWithSpotify profileWithSpotify = ProfileWithSpotify(
        user: userProfile,
        artist: spotifyArtistData,
      );

      // Assert
      expect(profileWithSpotify, isA<ProfileWithSpotify>());
      expect(profileWithSpotify.user, equals(userProfile));
      expect(profileWithSpotify.artist, equals(spotifyArtistData));
    });

    test('should access user properties correctly', () {
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
      final SpotifyArtistData spotifyArtistData = SpotifyArtistData(
        name: 'Test Artist',
        genres: 'pop, rock',
        imageUrl: 'test_image.jpg',
        biography: 'Test biography',
        tracks: <TrackEntity>[],
        popularity: 50,
        listeners: 1000,
      );

      // Act
      final ProfileWithSpotify profileWithSpotify = ProfileWithSpotify(
        user: userProfile,
        artist: spotifyArtistData,
      );

      // Assert
      expect(profileWithSpotify.user.id, equals(1));
      expect(profileWithSpotify.user.handle, equals('testuser'));
      expect(profileWithSpotify.user.displayName, equals('Test User'));
    });

    test('should access artist properties correctly', () {
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
      final SpotifyArtistData spotifyArtistData = SpotifyArtistData(
        name: 'Test Artist',
        genres: 'pop, rock',
        imageUrl: 'test_image.jpg',
        biography: 'Test biography',
        tracks: <TrackEntity>[],
        popularity: 50,
        listeners: 1000,
      );

      // Act
      final ProfileWithSpotify profileWithSpotify = ProfileWithSpotify(
        user: userProfile,
        artist: spotifyArtistData,
      );

      // Assert
      expect(profileWithSpotify.artist.name, equals('Test Artist'));
      expect(profileWithSpotify.artist.genres, equals('pop, rock'));
      expect(profileWithSpotify.artist.imageUrl, equals('test_image.jpg'));
      expect(profileWithSpotify.artist.popularity, equals(50));
      expect(profileWithSpotify.artist.listeners, equals(1000));
    });
  });
}
