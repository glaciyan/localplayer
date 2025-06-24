import 'package:dio/dio.dart';
import 'package:localplayer/core/services/spotify/data/services/config_service.dart';
import 'package:localplayer/core/services/spotify/spotify_module.dart';
import 'package:localplayer/features/profile/data/repositories/user_repository_impl.dart';
import 'package:localplayer/features/profile/domain/repositories/i_user_repository.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart';


class UserModule {
  static IUserRepository provideRepository(final Dio dio) => FakeUserRepository();

  static ProfileBloc provideBloc(final IUserRepository repo, final ConfigService config) => ProfileBloc(repo, SpotifyModule.provideService(config))..add(LoadProfile());
}