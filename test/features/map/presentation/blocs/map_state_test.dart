import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:localplayer/features/map/presentation/blocs/map_state.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';

void main() {
  group('MapState', () {
    test('MapInitial should be instance of MapInitial', () {
      // Arrange & Act
      final MapInitial state = MapInitial();

      // Assert
      expect(state, isA<MapInitial>());
    });

    test('MapLoading should be instance of MapLoading', () {
      // Arrange & Act
      final MapLoading state = MapLoading();

      // Assert
      expect(state, isA<MapLoading>());
    });

    test('MapError should have correct message', () {
      // Arrange
      const String message = 'Test error message';

      // Act
      final MapError state = MapError(message);

      // Assert
      expect(state.message, equals(message));
    });

    test('MapReady should have correct properties', () {
      // Arrange
      const double latitude = 40.7128;
      const double longitude = -74.0060;
      final LatLngBounds visibleBounds = LatLngBounds(
        LatLng(40.0, -74.0),
        LatLng(41.0, -73.0),
      );
      final List<UserProfile> visiblePeople = <UserProfile>[];
      const double zoom = 13.0;
      final UserProfile me = UserProfile(
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

      // Act
      final MapReady state = MapReady(
        latitude: latitude,
        longitude: longitude,
        visibleBounds: visibleBounds,
        visiblePeople: visiblePeople,
        zoom: zoom,
        me: me,
      );

      // Assert
      expect(state.latitude, equals(latitude));
      expect(state.longitude, equals(longitude));
      expect(state.visibleBounds, equals(visibleBounds));
      expect(state.visiblePeople, equals(visiblePeople));
      expect(state.zoom, equals(zoom));
      expect(state.me, equals(me));
    });

    test('MapReady copyWith should work correctly', () {
      // Arrange
      const double latitude = 40.7128;
      const double longitude = -74.0060;
      final LatLngBounds visibleBounds = LatLngBounds(
        LatLng(40.0, -74.0),
        LatLng(41.0, -73.0),
      );
      final List<UserProfile> visiblePeople = <UserProfile>[];
      const double zoom = 13.0;
      final UserProfile me = UserProfile(
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

      final MapReady state = MapReady(
        latitude: latitude,
        longitude: longitude,
        visibleBounds: visibleBounds,
        visiblePeople: visiblePeople,
        zoom: zoom,
        me: me,
      );

      // Act
      final MapReady newState = state.copyWith(zoom: 15.0);

      // Assert
      expect(newState.latitude, equals(latitude));
      expect(newState.longitude, equals(longitude));
      expect(newState.zoom, equals(15.0));
      expect(newState.me, equals(me));
    });

    test('MapProfileSelected should have correct properties', () {
      // Arrange
      const double latitude = 40.7128;
      const double longitude = -74.0060;
      final LatLngBounds visibleBounds = LatLngBounds(
        LatLng(40.0, -74.0),
        LatLng(41.0, -73.0),
      );
      final List<UserProfile> visiblePeople = <UserProfile>[];
      const double zoom = 13.0;
      final UserProfile me = UserProfile(
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
      final ProfileWithSpotify selectedUser = ProfileWithSpotify(
        user: me,
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
      final MapProfileSelected state = MapProfileSelected(
        latitude: latitude,
        longitude: longitude,
        visibleBounds: visibleBounds,
        visiblePeople: visiblePeople,
        zoom: zoom,
        selectedUser: selectedUser,
        me: me,
      );

      // Assert
      expect(state.latitude, equals(latitude));
      expect(state.longitude, equals(longitude));
      expect(state.visibleBounds, equals(visibleBounds));
      expect(state.visiblePeople, equals(visiblePeople));
      expect(state.zoom, equals(zoom));
      expect(state.selectedUser, equals(selectedUser));
      expect(state.me, equals(me));
    });

    test('MapProfileSelected copyWith should work correctly', () {
      // Arrange
      const double latitude = 40.7128;
      const double longitude = -74.0060;
      final LatLngBounds visibleBounds = LatLngBounds(
        LatLng(40.0, -74.0),
        LatLng(41.0, -73.0),
      );
      final List<UserProfile> visiblePeople = <UserProfile>[];
      const double zoom = 13.0;
      final UserProfile me = UserProfile(
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
      final ProfileWithSpotify selectedUser = ProfileWithSpotify(
        user: me,
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

      final MapProfileSelected state = MapProfileSelected(
        latitude: latitude,
        longitude: longitude,
        visibleBounds: visibleBounds,
        visiblePeople: visiblePeople,
        zoom: zoom,
        selectedUser: selectedUser,
        me: me,
      );

      // Act
      final MapProfileSelected newState = state.copyWith(zoom: 15.0);

      // Assert
      expect(newState.latitude, equals(latitude));
      expect(newState.longitude, equals(longitude));
      expect(newState.zoom, equals(15.0));
      expect(newState.selectedUser, equals(selectedUser));
      expect(newState.me, equals(me));
    });
  });
} 