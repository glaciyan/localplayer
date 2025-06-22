// features/match/presentation/blocs/match/match_event.dart\
import 'package:equatable/equatable.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';


abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfiles extends MatchEvent {}

class LikePressed extends MatchEvent {
  final UserProfile profile;
  const LikePressed(this.profile);

  @override
  List<Object?> get props => [profile];
}

class DislikePressed extends MatchEvent {
  final UserProfile profile;
  const DislikePressed(this.profile);

  @override
  List<Object?> get props => [profile];
}
class MatchNextProfile extends MatchEvent {}
