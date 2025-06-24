import 'package:localplayer/features/auth/data/IAuthRepository.dart';
import 'package:localplayer/features/auth/domain/controllers/auth_controller.dart';
import 'package:localplayer/features/auth/domain/interfaces/auth_controller_interface.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter/material.dart'; 
import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:localplayer/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:localplayer/spotify/data/services/config_service.dart';

class AuthModule {
  static AuthBloc provideBloc({
    required final IAuthRepository authRepository,
  }) => AuthBloc(
    authRepository: authRepository,
  );

  static IAuthController provideController(
    final BuildContext context,
    final AuthBloc bloc,
  ) => AuthController(context, bloc.add);

  static IAuthRepository provideRepository(final ConfigService config) => AuthRepository(AuthRemoteDataSource(ApiClient(baseUrl: config.apiBaseUrl)));
}