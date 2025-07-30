import 'package:flutter_test/flutter_test.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';
import 'package:localplayer/features/match/presentation/blocs/match_state.dart';
import 'package:localplayer/core/entities/user_profile.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';

void main() {
  group('MatchBloc', () {
    test('MatchEvent instances should be created correctly', () {
      // Test LoadProfiles
      final LoadProfiles loadProfilesEvent = LoadProfiles();
      expect(loadProfilesEvent, isA<LoadProfiles>());

      // Test MatchNextProfile
      final MatchNextProfile matchNextProfileEvent = MatchNextProfile();
      expect(matchNextProfileEvent, isA<MatchNextProfile>());

      // Test LikePressed
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
      final LikePressed likePressedEvent = LikePressed(userProfile);
      expect(likePressedEvent, isA<LikePressed>());
      expect(likePressedEvent.profile, equals(userProfile));

      // Test DislikePressed
      final DislikePressed dislikePressedEvent = DislikePressed(userProfile);
      expect(dislikePressedEvent, isA<DislikePressed>());
      expect(dislikePressedEvent.profile, equals(userProfile));
    });

    test('MatchState instances should be created correctly', () {
      // Test MatchInitial
      final MatchInitial matchInitialState = MatchInitial();
      expect(matchInitialState, isA<MatchInitial>());

      // Test MatchLoading
      final MatchLoading matchLoadingState = MatchLoading();
      expect(matchLoadingState, isA<MatchLoading>());

      // Test MatchError
      const String errorMessage = 'Test error message';
      final MatchError matchErrorState = MatchError(errorMessage);
      expect(matchErrorState, isA<MatchError>());
      expect(matchErrorState.message, equals(errorMessage));

      // Test ToastedMatchError
      const String toastedErrorMessage = 'Test toasted error message';
      final ToastedMatchError toastedMatchErrorState = ToastedMatchError(toastedErrorMessage);
      expect(toastedMatchErrorState, isA<ToastedMatchError>());
      expect(toastedMatchErrorState.message, equals(toastedErrorMessage));

      // Test MatchLoaded
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
      final ProfileWithSpotify  profileWithSpotify = ProfileWithSpotify(
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
      final MatchLoaded matchLoadedState = MatchLoaded(profiles, currentIndex: currentIndex);
      expect(matchLoadedState, isA<MatchLoaded>());
      expect(matchLoadedState.profiles, equals(profiles));
      expect(matchLoadedState.currentIndex, equals(currentIndex));
      expect(matchLoadedState.currentProfile, equals(profileWithSpotify));
    });
  });
}
