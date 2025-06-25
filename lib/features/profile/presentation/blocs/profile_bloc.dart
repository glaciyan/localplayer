import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/profile/data/profile_repository_interface.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IProfileRepository profileRepository;
  final ISpotifyRepository spotifyRepository;

  ProfileBloc({
    required this.profileRepository,
    required this.spotifyRepository,
  }) : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    final LoadProfile event,
    final Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      print('Loading profile');
      final ProfileWithSpotify profile = await profileRepository.fetchCurrentUserEnrichedProfile();
      print('Profile loaded: ${profile.user.id}');
      emit(
        ProfileLoaded(
          profile,
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
      await profileRepository.updateUserProfile(event.updatedProfile);
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }
}