import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('MapEvent', () {
    test('InitializeMap should be instance of InitializeMap', () {
      // Arrange & Act
      final InitializeMap initializeEvent = InitializeMap();

      // Assert
      expect(initializeEvent, isA<InitializeMap>());
    });

    test('UpdateCameraPosition should have correct properties', () {
      // Arrange
      const double latitude = 40.7128;
      const double longitude = -74.0060;
      final List<UserProfile> visiblePeople = <UserProfile>[];
      final LatLngBounds visibleBounds = LatLngBounds(
        LatLng(40.0, -74.0),
        LatLng(41.0, -73.0),
      );
      const double zoom = 13.0;

      // Act
      final UpdateCameraPosition updateCameraEvent = UpdateCameraPosition(
        latitude,
        longitude,
        visiblePeople,
        visibleBounds,
        zoom,
      );

      // Assert
      expect(updateCameraEvent.latitude, equals(latitude));
      expect(updateCameraEvent.longitude, equals(longitude));
      expect(updateCameraEvent.visiblePeople, equals(visiblePeople));
      expect(updateCameraEvent.visibleBounds, equals(visibleBounds));
      expect(updateCameraEvent.zoom, equals(zoom));
    });

    test('LoadMapProfiles should be instance of LoadMapProfiles', () {
      // Arrange & Act
      final LoadMapProfiles loadProfilesEvent = LoadMapProfiles();

      // Assert
      expect(loadProfilesEvent, isA<LoadMapProfiles>());
    });

    test('SelectPlayer should have correct selectedUser', () {
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

      // Act
      final SelectPlayer selectPlayerEvent = SelectPlayer(userProfile);

      // Assert
      expect(selectPlayerEvent.selectedUser, equals(userProfile));
    });

    test('DeselectPlayer should have correct properties', () {
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
      const double latitude = 40.7128;
      const double longitude = -74.0060;
      final LatLngBounds visibleBounds = LatLngBounds(
        LatLng(40.0, -74.0),
        LatLng(41.0, -73.0),
      );
      const double zoom = 13.0;

      // Act
      final DeselectPlayer deselectPlayerEvent = DeselectPlayer(
        userProfile,
        latitude,
        longitude,
        visibleBounds,
        zoom,
      );

      // Assert
      expect(deselectPlayerEvent.selectedUser, equals(userProfile));
      expect(deselectPlayerEvent.latitude, equals(latitude));
      expect(deselectPlayerEvent.longitude, equals(longitude));
      expect(deselectPlayerEvent.visibleBounds, equals(visibleBounds));
      expect(deselectPlayerEvent.zoom, equals(zoom));
    });

    test('RequestJoinSession should have correct selectedUser', () {
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

      // Act
      final RequestJoinSession requestJoinEvent = RequestJoinSession(userProfile);

      // Assert
      expect(requestJoinEvent.selectedUser, equals(userProfile));
    });

    test('LeaveSession should be instance of LeaveSession', () {
      // Arrange & Act
      final LeaveSession leaveSessionEvent = LeaveSession();

      // Assert
      expect(leaveSessionEvent, isA<LeaveSession>());
    });
  });
} 