import 'package:dio/dio.dart';
import 'package:localplayer/features/profile/data/repositories/user_repository_impl.dart';
import 'package:localplayer/features/profile/domain/repositories/i_user_repository.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_block.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart';
import 'package:localplayer/spotify/data/services/config_service.dart';
import 'package:localplayer/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/spotify/data/spotify_module.dart';

class UserModule {
  static IUserRepository provideRepository(Dio dio) {

    return FakeUserRepository();
  }

  static ProfileBloc provideBloc(IUserRepository repo, ConfigService config) {
    final spotifyService = SpotifyModule.provideService(config);
    return ProfileBloc(repo, spotifyService)..add(LoadProfile());
  }
}
