// features/match/presentation/blocs/match/match_event.dart\
import 'package:equatable/equatable.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';


abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object?> get props => <Object?> [];
}

class LoadProfiles extends MatchEvent {}

class LikePressed extends MatchEvent {
  final UserProfile profile;
  const LikePressed(this.profile);

  @override
  List<Object?> get props => <Object?> [profile];
}

class DislikePressed extends MatchEvent {
  final UserProfile profile;
  const DislikePressed(this.profile);

  @override
  List<Object?> get props => <Object?> [profile];
}
class MatchNextProfile extends MatchEvent {}
