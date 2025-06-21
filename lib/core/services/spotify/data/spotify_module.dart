import 'package:localplayer/core/services/spotify/data/repositories/track_repository_impl.dart';
import 'package:localplayer/core/services/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/track_repository.dart';
import 'package:localplayer/core/services/spotify/domain/usecases/get_track_use_case.dart';
import 'package:localplayer/core/services/spotify/presentation/blocs/track_preview_cubit.dart';
import 'package:localplayer/core/services/spotify/data/services/config_service.dart';

class SpotifyModule {
  static TrackPreviewCubit provideCubit(ConfigService config) {
    final apiService = SpotifyApiService(
      clientId: config.clientId,
      clientSecret: config.clientSecret,
    );

    final ITrackRepository repository = TrackRepositoryImpl(apiService);
    final getTrackUseCase = GetTrackUseCase(repository);

    return TrackPreviewCubit(getTrackUseCase);
  }

  static SpotifyApiService provideService(ConfigService config) =>
      SpotifyApiService(
        clientId: config.clientId,
        clientSecret: config.clientSecret,
      );

  static ITrackRepository provideRepository(ConfigService config) =>
      TrackRepositoryImpl(provideService(config));
}