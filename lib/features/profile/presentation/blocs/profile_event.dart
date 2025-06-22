import 'package:localplayer/core/entities/profile_with_spotify.dart';

sealed class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class ProfileUpdated extends ProfileEvent {
  final String displayName;
  final String biography;

  ProfileUpdated({required this.displayName, required this.biography});
}

class UpdateProfile extends ProfileEvent {
  final ProfileWithSpotify updatedProfile;

  UpdateProfile(this.updatedProfile);
}
