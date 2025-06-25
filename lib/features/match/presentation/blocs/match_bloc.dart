// features/match/presentation/blocs/match/match_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/features/match/data/match_repository_interface.dart';
import 'match_event.dart';
import 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final IMatchRepository repository;
  final ISpotifyRepository spotifyRepository;

  MatchBloc({
    required this.repository,
    required this.spotifyRepository,
  }) : super(MatchInitial()) {
    on<LoadProfiles>(_onLoadProfiles);
    on<MatchNextProfile>(_onMatchNextProfile);
    on<LikePressed>(_onLikePressed);
    on<DislikePressed>(_onDislikePressed);
  }

  Future<void> _onLoadProfiles(final LoadProfiles event, final Emitter<MatchState> emit) async {
    emit(MatchLoading());
    try {
      final List<ProfileWithSpotify> profiles = await repository.fetchProfilesWithSpotify(0, 0, 1000000);
      emit(MatchLoaded(profiles));
    } catch (e) {
      emit(MatchError('Failed to load profiles.'));
    }
  }

  void _onMatchNextProfile(final MatchNextProfile event, final Emitter<MatchState> emit) async {
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
        //print('Preloading next Spotify profile failed.');
      }
    }
  }

  void _onLikePressed(final LikePressed event, final Emitter<MatchState> emit) async {
    if (state is MatchLoaded) {
      // Implementation for like action
    }
  }

  void _onDislikePressed(final DislikePressed event, final Emitter<MatchState> emit) async {
    if (state is MatchLoaded) {
      // Implementation for dislike action
    }
  }
}
