import 'package:localplayer/core/entities/profile_with_spotify.dart';

sealed class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileWithSpotify profile;

  ProfileLoaded(this.profile);
}

class ProfileSignedOut extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileUpdateSuccess extends ProfileState {}
