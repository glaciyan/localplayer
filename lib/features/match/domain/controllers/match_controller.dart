import 'package:flutter/widgets.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/match/domain/controllers/match_controller_interface.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';

class MatchController implements IMatchController {
  final BuildContext context;
  final void Function(MatchEvent) addEvent;

  MatchController(this.context, this.addEvent);

  @override
  void like(final ProfileWithSpotify profile) {
    addEvent(LikePressed(profile.user));
  }

  @override
  void dislike(final ProfileWithSpotify profile) {
    addEvent(DislikePressed(profile.user));
  }

  @override
  void loadProfiles() {
    addEvent(LoadProfiles());
  }
}