import 'package:flutter/widgets.dart';
import 'package:localplayer/features/match/domain/controllers/IMatchController.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';

class MatchController implements IMatchController {
  final BuildContext context;
  final void Function(MatchEvent) addEvent;

  MatchController(this.context, this.addEvent);

  @override
  void like(UserProfile profile) {
    addEvent(LikePressed(profile));
  }

  @override
  void dislike(UserProfile profile) {
    addEvent(DislikePressed(profile));
  }

  @override
  void loadProfiles() {
    addEvent(LoadProfiles());
  }
}