import 'package:localplayer/spotify/data/repositories/spotify_repository_impl.dart';
import 'package:localplayer/spotify/data/repositories/track_repository_impl.dart';
import 'package:localplayer/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/spotify/domain/repositories/track_repository.dart';
import 'package:localplayer/spotify/domain/usecases/get_spotify_artist_data_use_case.dart';
import 'package:localplayer/spotify/domain/usecases/get_track_use_case.dart';
import 'package:localplayer/spotify/presentation/blocs/track_preview_cubit.dart';
import 'package:localplayer/spotify/data/services/config_service.dart';

class SpotifyModule {
  static SpotifyApiService provideService(final ConfigService config) =>
      SpotifyApiService(
        clientId: config.clientId,
        clientSecret: config.clientSecret,
      );

  static ITrackRepository provideTrackRepository(final ConfigService config) =>
      TrackRepositoryImpl(provideService(config));

  static ISpotifyRepository provideRepository(final ConfigService config) =>
      SpotifyRepositoryImpl(provideService(config));

  static GetSpotifyArtistDataUseCase provideUseCase(final ConfigService config) =>
      GetSpotifyArtistDataUseCase(provideRepository(config));

  static TrackPreviewCubit provideCubit(final ConfigService config) =>
      TrackPreviewCubit(GetTrackUseCase(TrackRepositoryImpl(provideService(config))));
}
