import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/profile/data/profile_repository_interface.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart' as profile_event;

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IProfileRepository profileRepository;
  final ISpotifyRepository spotifyRepository;

  ProfileBloc({
    required this.profileRepository,
    required this.spotifyRepository,
  }) : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<profile_event.ProfileUpdateSuccess>(_onProfileUpdateSuccess);
    on<profile_event.SignOut>(_onSignOut);
  }

  Future<void> _onLoadProfile(
    final LoadProfile event,
    final Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final ProfileWithSpotify profile = await profileRepository.fetchCurrentUserEnrichedProfile();
      print('Profile loaded: ${profile.user.position}');
      emit(
        ProfileLoaded(
          profile,
          false
        ),
      );
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  Future<void> _onUpdateProfile(
    final UpdateProfile event,
    final Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final ProfileWithSpotify profile = await profileRepository.updateUserProfile(event.updatedProfile);
      emit(ProfileLoaded(profile, true));
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }

  Future<void> _onProfileUpdateSuccess(
    final profile_event.ProfileUpdateSuccess event,
    final Emitter<ProfileState> emit,
  ) async {
    // await _onLoadProfile(LoadProfile(), emit);
  }

  Future<void> _onSignOut(
    final profile_event.SignOut event,
    final Emitter<ProfileState> emit,
  ) async {
    await profileRepository.signOut();
    emit(ProfileSignedOut());
  }
}