// features/match/presentation/blocs/match/match_state.dart
import 'package:equatable/equatable.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';


abstract class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object?> get props => <Object?> [];
}

class MatchInitial extends MatchState {}

class MatchLoading extends MatchState {}

class MatchLoaded extends MatchState {
  final List<ProfileWithSpotify> profiles;
  final int currentIndex;

  const MatchLoaded(this.profiles, {this.currentIndex = 0});

  ProfileWithSpotify get currentProfile => profiles[currentIndex];

  bool get hasMore => currentIndex < profiles.length - 1;

  MatchLoaded copyWith({final int? currentIndex}) => MatchLoaded(
      profiles,
      currentIndex: currentIndex ?? this.currentIndex,
    );

  @override
  List<Object?> get props => <Object?> [profiles, currentIndex];
}



class MatchError extends MatchState {
  final String message;

  const MatchError(this.message);

  @override
  List<Object?> get props => <Object?> [message];
}
