import 'package:flutter/material.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/core/services/spotify/data/services/config_service.dart';
import 'package:localplayer/features/session/data/datasources/session_remote_data_source.dart';
import 'package:localplayer/features/session/data/repositories/session_repository_impl.dart';
import 'package:localplayer/features/session/data/session_repository_interface.dart';
import 'package:localplayer/features/session/domain/controllers/session_controller.dart';
import 'package:localplayer/features/session/domain/interfaces/session_controller_interface.dart';
import 'package:localplayer/features/session/presentation/blocs/session_bloc.dart';

class SessionModule {
  static SessionBloc provideBloc({required final ISessionRepository repository}) =>
      SessionBloc(repository: repository);

  static ISessionController provideController(
    final BuildContext context,
    final SessionBloc bloc,
  ) => SessionController(context, bloc.add);

  static ISessionRepository provideRepository(final ConfigService config) =>
      SessionRepository(
        SessionRemoteDataSource(ApiClient(baseUrl: config.apiBaseUrl)),
      );
}
