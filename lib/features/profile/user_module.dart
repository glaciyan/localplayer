import 'package:dio/dio.dart';
import 'package:localplayer/features/profile/data/repositories/user_repository_impl.dart';
import 'package:localplayer/features/profile/domain/repositories/i_user_repository.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart';
import 'package:localplayer/spotify/data/services/config_service.dart';
import 'package:localplayer/spotify/data/spotify_module.dart';

class UserModule {
  static IUserRepository provideRepository(final Dio dio) => FakeUserRepository();

  static ProfileBloc provideBloc(final IUserRepository repo, final ConfigService config) => ProfileBloc(repo, SpotifyModule.provideService(config))..add(LoadProfile());
}