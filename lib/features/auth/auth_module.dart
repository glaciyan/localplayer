import 'package:localplayer/core/services/spotify/data/services/config_service.dart';
import 'package:localplayer/features/auth/data/IAuthRepository.dart';
import 'package:localplayer/features/auth/domain/controllers/auth_controller.dart';
import 'package:localplayer/features/auth/domain/interfaces/auth_controller_interface.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter/material.dart'; 
import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:localplayer/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:localplayer/core/services/geolocator/geolocator_interface.dart';
import 'package:localplayer/core/services/presence/presence_interface.dart';


class AuthModule {
  static AuthBloc provideBloc({
    required final IAuthRepository authRepository,
    required final IGeolocatorService geolocatorService,
    required final IPresenceService presenceService,
  }) => AuthBloc(
    authRepository: authRepository,
    geolocatorService: geolocatorService,
    presenceService: presenceService,
  );

  static IAuthController provideController(
    final BuildContext context,
    final AuthBloc bloc,
  ) => AuthController(context, bloc.add);

  static IAuthRepository provideRepository(final ConfigService config) => AuthRepository(AuthRemoteDataSource(ApiClient(baseUrl: config.apiBaseUrl)), config);
}