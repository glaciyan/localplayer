import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart' as profile_event;
import 'package:localplayer/features/profile/presentation/blocs/profile_state.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

void main() {
  group('ProfileBloc', () {
    test('ProfileEvent instances should be created correctly', () {
      // Test LoadProfile
      final loadProfileEvent = profile_event.LoadProfile();
      expect(loadProfileEvent, isA<profile_event.LoadProfile>());
      expect(loadProfileEvent.updatedProfile, isNull);

      // Test ProfileUpdated
      const displayName = 'Test User';
      const biography = 'Test biography';
      final profileUpdatedEvent = profile_event.ProfileUpdated(displayName: displayName, biography: biography);
      expect(profileUpdatedEvent, isA<profile_event.ProfileUpdated>());
      expect(profileUpdatedEvent.displayName, equals(displayName));
      expect(profileUpdatedEvent.biography, equals(biography));

      // Test UpdateProfile
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
      final profileWithSpotify = ProfileWithSpotify(
        user: userProfile,
        artist: SpotifyArtistData(
          name: 'Test Artist',
          genres: 'pop, rock',
          imageUrl: 'test_image.jpg',
          biography: 'Test biography',
          tracks: [],
          popularity: 50,
          listeners: 1000,
        ),
      );
      final updateProfileEvent = profile_event.UpdateProfile(profileWithSpotify);
      expect(updateProfileEvent, isA<profile_event.UpdateProfile>());
      expect(updateProfileEvent.updatedProfile, equals(profileWithSpotify));

      // Test SignOut
      final signOutEvent = profile_event.SignOut();
      expect(signOutEvent, isA<profile_event.SignOut>());

      // Test ProfileUpdateSuccess
      final profileUpdateSuccessEvent = profile_event.ProfileUpdateSuccess();
      expect(profileUpdateSuccessEvent, isA<profile_event.ProfileUpdateSuccess>());
    });

    test('ProfileState instances should be created correctly', () {
      // Test ProfileLoading
      final profileLoadingState = ProfileLoading();
      expect(profileLoadingState, isA<ProfileLoading>());

      // Test ProfileLoaded
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
      final profileWithSpotify = ProfileWithSpotify(
        user: userProfile,
        artist: SpotifyArtistData(
          name: 'Test Artist',
          genres: 'pop, rock',
          imageUrl: 'test_image.jpg',
          biography: 'Test biography',
          tracks: [],
          popularity: 50,
          listeners: 1000,
        ),
      );
      const updated = false;
      final profileLoadedState = ProfileLoaded(profileWithSpotify, updated);
      expect(profileLoadedState, isA<ProfileLoaded>());
      expect(profileLoadedState.profile, equals(profileWithSpotify));
      expect(profileLoadedState.updated, equals(updated));

      // Test ProfileSignedOut
      final profileSignedOutState = ProfileSignedOut();
      expect(profileSignedOutState, isA<ProfileSignedOut>());

      // Test ProfileError
      const errorMessage = 'Test error message';
      final profileErrorState = ProfileError(errorMessage);
      expect(profileErrorState, isA<ProfileError>());
      expect(profileErrorState.message, equals(errorMessage));

      // Test ProfileUpdateSuccess
      final profileUpdateSuccessState = ProfileUpdateSuccess();
      expect(profileUpdateSuccessState, isA<ProfileUpdateSuccess>());
    });
  });
}
