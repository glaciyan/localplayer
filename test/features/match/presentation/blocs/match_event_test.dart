import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('MatchEvent', () {
    test('LoadProfiles should be instance of LoadProfiles', () {
      // Arrange & Act
      final LoadProfiles event = LoadProfiles();

      // Assert
      expect(event, isA<LoadProfiles>());
    });

    test('MatchNextProfile should be instance of MatchNextProfile', () {
      // Arrange & Act
      final MatchNextProfile event = MatchNextProfile();

      // Assert
      expect(event, isA<MatchNextProfile>());
    });

    test('LikePressed should have correct profile', () {
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
      final LikePressed event = LikePressed(userProfile);

      // Assert
      expect(event.profile, equals(userProfile));
    });

    test('DislikePressed should have correct profile', () {
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
      final DislikePressed event = DislikePressed(userProfile);

      // Assert
      expect(event.profile, equals(userProfile));
    });
  });
}
