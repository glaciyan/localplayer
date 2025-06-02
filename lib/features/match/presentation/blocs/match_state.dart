// features/match/presentation/blocs/match/match_state.dart
import 'package:equatable/equatable.dart';
import 'package:localplayer/features/match/domain/entities/UserProfile.dart';


abstract class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object?> get props => [];
}

class MatchInitial extends MatchState {}

class MatchLoading extends MatchState {}

class MatchLoaded extends MatchState {
  final List<UserProfile> profiles;

  const MatchLoaded(this.profiles);

  @override
  List<Object?> get props => [profiles];
}


class MatchError extends MatchState {
  final String message;

  const MatchError(this.message);

  @override
  List<Object?> get props => [message];
}
