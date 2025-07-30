import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart' as profile_event;
import 'package:localplayer/features/profile/presentation/blocs/profile_state.dart' as profile_state;

void main() {
  group('ProfileBloc', () {
    test('ProfileEvent instances should be created correctly', () {
      // Test LoadProfile
      final profile_event.LoadProfile loadProfileEvent = profile_event.LoadProfile();
      expect(loadProfileEvent, isA<profile_event.LoadProfile>());
      expect(loadProfileEvent.updatedProfile, isNull);

      // Test ProfileUpdated
      const String displayName = 'Test User';
      const String biography = 'Test biography';
      final profile_event.ProfileUpdated profileUpdatedEvent = profile_event.ProfileUpdated(displayName: displayName, biography: biography);
      expect(profileUpdatedEvent, isA<profile_event.ProfileUpdated>());
      expect(profileUpdatedEvent.displayName, equals(displayName));
      expect(profileUpdatedEvent.biography, equals(biography));

      // Test UpdateProfile
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
      final profile_event.UpdateProfile updateProfileEvent = profile_event.UpdateProfile(profileWithSpotify);
      expect(updateProfileEvent, isA<profile_event.UpdateProfile>());
      expect(updateProfileEvent.updatedProfile, equals(profileWithSpotify));

      // Test SignOut
      final profile_event.SignOut signOutEvent = profile_event.SignOut();
      expect(signOutEvent, isA<profile_event.SignOut>());

      // Test ProfileUpdateSuccess
      final profile_event.ProfileUpdateSuccess profileUpdateSuccessEvent = profile_event.ProfileUpdateSuccess();
      expect(profileUpdateSuccessEvent, isA<profile_event.ProfileUpdateSuccess>());
    });

    test('ProfileState instances should be created correctly', () {
      // Test ProfileLoading
      final profile_state.ProfileLoading profileLoadingState = profile_state.ProfileLoading();
      expect(profileLoadingState, isA<profile_state.ProfileLoading>());

      // Test ProfileLoaded
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
      final profile_state.ProfileLoaded profileLoadedState = profile_state.ProfileLoaded(profileWithSpotify, updated);
      expect(profileLoadedState, isA<profile_state.ProfileLoaded>());
      expect(profileLoadedState.profile, equals(profileWithSpotify));
      expect(profileLoadedState.updated, equals(updated));

      // Test ProfileSignedOut
      final profile_state.ProfileSignedOut profileSignedOutState = profile_state.ProfileSignedOut();
      expect(profileSignedOutState, isA<profile_state.ProfileSignedOut>());

      // Test ProfileError
      const String errorMessage = 'Test error message';
      final profile_state.ProfileError profileErrorState = profile_state.ProfileError(errorMessage);
      expect(profileErrorState, isA<profile_state.ProfileError>());
      expect(profileErrorState.message, equals(errorMessage));

      // Test ProfileUpdateSuccess
      final profile_state.ProfileUpdateSuccess profileUpdateSuccessState = profile_state.ProfileUpdateSuccess();
      expect(profileUpdateSuccessState, isA<profile_state.ProfileUpdateSuccess>());
    });
  });
}
