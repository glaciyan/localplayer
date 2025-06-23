// features/match/presentation/blocs/match/match_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import 'package:localplayer/features/match/domain/repositories/match_repository.dart';
import 'package:localplayer/features/match/domain/usecases/dislike_user_usecase.dart';
import 'package:localplayer/features/match/domain/usecases/like_user_usecase.dart';
import 'package:localplayer/spotify/domain/repositories/spotify_repository.dart';
import 'match_event.dart';
import 'match_state.dart';
import 'package:localplayer/spotify/domain/entities/spotify_artist_data.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final LikeUserUseCase likeUseCase;
  final DislikeUserUseCase dislikeUseCase;
  final MatchRepository repository;
  final ISpotifyRepository spotifyRepository;

  MatchBloc({
    required this.likeUseCase,
    required this.dislikeUseCase,
    required this.repository,
    required this.spotifyRepository,
  }) : super(MatchInitial()) {
    // Load profiles initially
    on<LoadProfiles>((final LoadProfiles event, final Emitter<MatchState> emit) async {
      emit(MatchLoading());
      try {
        final List<UserProfile> rawProfiles = await repository.fetchProfiles();

        final List<ProfileWithSpotify> enrichedProfiles = await Future.wait(
          rawProfiles.map((final UserProfile user) async {
            final SpotifyArtistData artist = await spotifyRepository.fetchArtistData(user.spotifyId);
            return ProfileWithSpotify(user: user, artist: artist);
          }),
        );

        emit(MatchLoaded(enrichedProfiles));
      } catch (e, stack) {
        print('Failed to load profiles: $e');
        print(stack);
        emit(MatchError('Failed to load profiles.'));
      }
    });

    // Skip to next profile
    on<MatchNextProfile>((final MatchNextProfile event, final Emitter<MatchState> emit) async {
      final MatchState state = this.state;
      if (state is! MatchLoaded) return;

      final int nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.profiles.length) return;

      emit(state.copyWith(currentIndex: nextIndex));

      // Optionally preload the next+1 profile's Spotify data
      if (nextIndex + 1 < state.profiles.length) {
        final String preloadId = state.profiles[nextIndex + 1].user.spotifyId;
        try {
          await spotifyRepository.fetchArtistData(preloadId);
        } catch (_) {
          print('Preloading next Spotify profile failed.');
        }
      }
    });

    on<LikePressed>((final LikePressed event, final Emitter<MatchState> emit) async {
      if (state is MatchLoaded) {
        await likeUseCase(event.profile);
      }
    });

    on<DislikePressed>((final DislikePressed event, final Emitter<MatchState> emit) async {
      if (state is MatchLoaded) {
        await dislikeUseCase(event.profile);
      }
    });
  }
}
