import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

void main() {
  group('MapBloc', () {
    test('MapEvent instances should be created correctly', () {
      // Test InitializeMap
      final InitializeMap initializeEvent = InitializeMap();
      expect(initializeEvent, isA<InitializeMap>());

      // Test LoadMapProfiles
      final LoadMapProfiles loadProfilesEvent = LoadMapProfiles();
      expect(loadProfilesEvent, isA<LoadMapProfiles>());

      // Test SelectPlayer
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
      final SelectPlayer selectPlayerEvent = SelectPlayer(userProfile);
      expect(selectPlayerEvent, isA<SelectPlayer>());
      expect(selectPlayerEvent.selectedUser, equals(userProfile));

      // Test RequestJoinSession
      final RequestJoinSession requestJoinEvent = RequestJoinSession(userProfile);
      expect(requestJoinEvent, isA<RequestJoinSession>());
      expect(requestJoinEvent.selectedUser, equals(userProfile));

      // Test LeaveSession
      final LeaveSession leaveSessionEvent = LeaveSession();
      expect(leaveSessionEvent, isA<LeaveSession>());

      // Test UpdateCameraPosition
      const double latitude = 40.7128;
      const double longitude = -74.0060;
      final List<UserProfile> visiblePeople = <UserProfile>[];
      final LatLngBounds visibleBounds = LatLngBounds(
        LatLng(40.0, -74.0),
        LatLng(41.0, -73.0),
      );
      const double zoom = 13.0;
      final UpdateCameraPosition updateCameraEvent = UpdateCameraPosition(
        latitude,
        longitude,
        visiblePeople,
        visibleBounds,
        zoom,
      );
      expect(updateCameraEvent, isA<UpdateCameraPosition>());
      expect(updateCameraEvent.latitude, equals(latitude));
      expect(updateCameraEvent.longitude, equals(longitude));
      expect(updateCameraEvent.zoom, equals(zoom));

      // Test DeselectPlayer
      final DeselectPlayer deselectPlayerEvent = DeselectPlayer(
        userProfile,
        latitude,
        longitude,
        visibleBounds,
        zoom,
      );
      expect(deselectPlayerEvent, isA<DeselectPlayer>());
      expect(deselectPlayerEvent.selectedUser, equals(userProfile));
      expect(deselectPlayerEvent.latitude, equals(latitude));
      expect(deselectPlayerEvent.longitude, equals(longitude));
      expect(deselectPlayerEvent.zoom, equals(zoom));
    });
  });
} 