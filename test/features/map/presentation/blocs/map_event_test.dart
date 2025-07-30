import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('MapEvent', () {
    test('InitializeMap should be instance of InitializeMap', () {
      // Arrange & Act
      final event = InitializeMap();

      // Assert
      expect(event, isA<InitializeMap>());
    });

    test('UpdateCameraPosition should have correct properties', () {
      // Arrange
      const latitude = 40.7128;
      const longitude = -74.0060;
      final visiblePeople = <UserProfile>[];
      final visibleBounds = LatLngBounds(
        LatLng(40.0, -74.0),
        LatLng(41.0, -73.0),
      );
      const zoom = 13.0;

      // Act
      final event = UpdateCameraPosition(
        latitude,
        longitude,
        visiblePeople,
        visibleBounds,
        zoom,
      );

      // Assert
      expect(event.latitude, equals(latitude));
      expect(event.longitude, equals(longitude));
      expect(event.visiblePeople, equals(visiblePeople));
      expect(event.visibleBounds, equals(visibleBounds));
      expect(event.zoom, equals(zoom));
    });

    test('LoadMapProfiles should be instance of LoadMapProfiles', () {
      // Arrange & Act
      final event = LoadMapProfiles();

      // Assert
      expect(event, isA<LoadMapProfiles>());
    });

    test('SelectPlayer should have correct selectedUser', () {
      // Arrange
      final userProfile = UserProfile(
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
      final event = SelectPlayer(userProfile);

      // Assert
      expect(event.selectedUser, equals(userProfile));
    });

    test('DeselectPlayer should have correct properties', () {
      // Arrange
      final userProfile = UserProfile(
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
      const latitude = 40.7128;
      const longitude = -74.0060;
      final visibleBounds = LatLngBounds(
        LatLng(40.0, -74.0),
        LatLng(41.0, -73.0),
      );
      const zoom = 13.0;

      // Act
      final event = DeselectPlayer(
        userProfile,
        latitude,
        longitude,
        visibleBounds,
        zoom,
      );

      // Assert
      expect(event.selectedUser, equals(userProfile));
      expect(event.latitude, equals(latitude));
      expect(event.longitude, equals(longitude));
      expect(event.visibleBounds, equals(visibleBounds));
      expect(event.zoom, equals(zoom));
    });

    test('RequestJoinSession should have correct selectedUser', () {
      // Arrange
      final userProfile = UserProfile(
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
      final event = RequestJoinSession(userProfile);

      // Assert
      expect(event.selectedUser, equals(userProfile));
    });

    test('LeaveSession should be instance of LeaveSession', () {
      // Arrange & Act
      final event = LeaveSession();

      // Assert
      expect(event, isA<LeaveSession>());
    });
  });
} 