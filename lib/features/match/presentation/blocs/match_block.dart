// features/match/presentation/blocs/match/match_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/features/match/domain/repositories/match_repository.dart';
import 'package:localplayer/features/match/domain/usecases/dislike_user_usecase.dart';
import 'package:localplayer/features/match/domain/usecases/like_user_usecase.dart';
import 'match_event.dart';
import 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final LikeUserUseCase likeUseCase;
  final DislikeUserUseCase dislikeUseCase;
  final MatchRepository repository;

  MatchBloc({
    required this.likeUseCase,
    required this.dislikeUseCase,
    required this.repository,
  }) : super(MatchInitial()) {
  on<LoadProfiles>((event, emit) async {
    emit(MatchLoading());
    try {
      final profiles = await repository.fetchProfiles();
      emit(MatchLoaded(profiles));
    } catch (e, stack) {
      print('❌ Failed to load profiles: $e');
      print(stack); // optional: shows where it failed
      emit(MatchError('Failed to load profiles.'));
    }
  });

    on<LikePressed>((event, emit) async {
      final state = this.state;
      if (state is MatchLoaded) {
        final profile = state.currentProfile;
        await likeUseCase(profile);

        if (state.hasMore) {
          emit(state.copyWith(currentIndex: state.currentIndex + 1));
        } else {
          emit(MatchInitial());
        }
      }
    });

    on<DislikePressed>((event, emit) async {
      final state = this.state;
      if (state is MatchLoaded) {
        final profile = state.currentProfile;
        await dislikeUseCase(profile);

        if (state.hasMore) {
          emit(state.copyWith(currentIndex: state.currentIndex + 1));
        } else {
          emit(MatchInitial());
        }
      }
    });
  }
}

