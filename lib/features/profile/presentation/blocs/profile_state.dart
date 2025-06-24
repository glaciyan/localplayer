import 'package:localplayer/core/entities/profile_with_spotify.dart';

sealed class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileWithSpotify profile;

  ProfileLoaded(this.profile);
}


class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
