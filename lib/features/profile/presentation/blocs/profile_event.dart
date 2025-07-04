import 'package:localplayer/core/entities/profile_with_spotify.dart';

sealed class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  ProfileWithSpotify? get updatedProfile => null;
}

class ProfileUpdated extends ProfileEvent {
  final String displayName;
  final String biography;

  ProfileUpdated({required this.displayName, required this.biography});
}

class UpdateProfile extends ProfileEvent {
  final ProfileWithSpotify updatedProfile;

  UpdateProfile(this.updatedProfile);
}

class SignOut extends ProfileEvent {}

class ProfileUpdateSuccess extends ProfileEvent {}
