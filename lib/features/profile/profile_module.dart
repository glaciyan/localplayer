import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/core/services/spotify/data/services/config_service.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:localplayer/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:localplayer/features/profile/data/profile_repository_interface.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:localplayer/features/profile/domain/interfaces/profile_controller_interface.dart';
import 'package:localplayer/features/profile/domain/controllers/profile_controller.dart';
import 'package:flutter/material.dart';


class ProfileModule {
  static ProfileBloc provideBloc({
    required final IProfileRepository profileRepository,
    required final ISpotifyRepository spotifyRepository,
  }) => ProfileBloc(
    profileRepository: profileRepository,
    spotifyRepository: spotifyRepository,
  );

  static IProfileController provideController(
    final BuildContext context,
    final ProfileBloc bloc
  ) => ProfileController(context, bloc.add);

  static IProfileRepository provideRepository(final ConfigService config, final ISpotifyRepository spotifyRepository) =>
      ProfileRepositoryImpl(
        ProfileRemoteDataSource(ApiClient(baseUrl: config.apiBaseUrl)),
        spotifyRepository,
      );
} 