import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/profile/domain/interfaces/profile_controller_interface.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart';

class ProfileController implements IProfileController {
  final BuildContext context;
  final Function(ProfileEvent) addEvent;

  ProfileController(this.context, this.addEvent);

  @override
  void updateProfile(final ProfileWithSpotify profile) => addEvent(UpdateProfile(profile));

  @override
  void getCurrentUserProfile() => addEvent(LoadProfile());

  @override
  void signOut() => addEvent(SignOut());
}