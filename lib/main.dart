import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localplayer/core/go_router/router.dart';
import 'package:localplayer/core/services/geolocator/geolocator_interface.dart';
import 'package:localplayer/core/services/presence/presence_interface.dart';
import 'package:localplayer/core/services/spotify/data/services/config_service.dart';
import 'package:localplayer/core/services/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/track_repository.dart';
import 'package:localplayer/core/services/spotify/domain/usecases/get_spotify_artist_data_use_case.dart';
import 'package:localplayer/core/services/spotify/presentation/blocs/spotify_profile_cubit.dart';
import 'package:localplayer/core/services/spotify/spotify_module.dart';
import 'package:localplayer/features/auth/auth_module.dart';
import 'package:localplayer/features/auth/data/IAuthRepository.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:localplayer/features/feed/data/feed_repository_interface.dart';
import 'package:localplayer/features/feed/feed_module.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_event.dart';
import 'package:localplayer/features/map/data/map_repository_interface.dart';
import 'package:localplayer/features/map/map_module.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart';
import 'package:localplayer/features/match/match_module.dart';
import 'package:localplayer/features/match/presentation/blocs/match_bloc.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';
import 'package:localplayer/features/session/data/session_repository_interface.dart';
import 'package:localplayer/features/session/presentation/blocs/session_bloc.dart';
import 'package:localplayer/features/session/presentation/blocs/session_event.dart';
import 'package:localplayer/features/session/session_module.dart';
import 'package:localplayer/features/profile/data/profile_repository_interface.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart';
import 'package:localplayer/features/profile/profile_module.dart';
import 'package:localplayer/features/match/data/match_repository_interface.dart';
import 'package:localplayer/core/services/geolocator/geolocator_impl.dart';
import 'package:localplayer/core/services/presence/presence_impl.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:logger/logger.dart';

final Logger log = Logger(printer: PrettyPrinter());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  io.HttpClient.enableTimelineLogging = true;

  final ConfigService config = ConfigService();
  await config.load();
  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final ConfigService config;

  const MyApp({
    required this.config,
    super.key,
  });

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ConfigService>('config', config));
  }

  @override
  Widget build(final BuildContext context) => MultiRepositoryProvider(
      providers: <RepositoryProvider<dynamic>>[
        RepositoryProvider<ConfigService>.value(value: config),
        RepositoryProvider<IGeolocatorService>(
          create: (_) => GeolocatorService(),
        ),
        RepositoryProvider<IPresenceService>(
          create: (final BuildContext context) => PresenceService(
            ApiClient(baseUrl: config.apiBaseUrl),
          ),
        ),
        RepositoryProvider<SpotifyApiService>(
          create: (_) => SpotifyModule.provideService(config),
        ),
        RepositoryProvider<ITrackRepository>(
          create: (_) => SpotifyModule.provideTrackRepository(config),
        ),
        RepositoryProvider<ISpotifyRepository>(
          create: (_) => SpotifyModule.provideRepository(config),
        ),
        RepositoryProvider<GetSpotifyArtistDataUseCase>(
          create: (_) => SpotifyModule.provideUseCase(config),
        ),
        RepositoryProvider<IMapRepository>(
          create: (final BuildContext context) 
          => MapModule.provideRepository(config, context.read<ISpotifyRepository>()),
        ),
        RepositoryProvider<IProfileRepository>(
          create: (final BuildContext context) 
          => ProfileModule.provideRepository(config, context.read<ISpotifyRepository>()),
        ),
        RepositoryProvider<IAuthRepository>(
          create: (_) => AuthModule.provideRepository(config),
        ),
        RepositoryProvider<IFeedRepository>(
          create: (_) => FeedModule.provideRepository(config),
        ),
        RepositoryProvider<IMatchRepository>(
          create: (final BuildContext context) => MatchModule.provideRepository(context.read<ISpotifyRepository>(), config),
        ),
        RepositoryProvider<ISessionRepository>(
          create: (_) => SessionModule.provideRepository(config),
        ),
      ],
      child: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<MatchBloc>(
            create: (final BuildContext context) => MatchModule.provideBloc(
              matchRepository: context.read<IMatchRepository>(),
              spotifyRepository: context.read<ISpotifyRepository>(),
            )..add(LoadProfiles()),
          ),
          BlocProvider<ProfileBloc>(
            create: (final BuildContext context) => ProfileModule.provideBloc(
              profileRepository: context.read<IProfileRepository>(),
              spotifyRepository: context.read<ISpotifyRepository>(),
            )..add(LoadProfile()),
          ),
          BlocProvider<FeedBloc>(
            create: (final BuildContext context) => FeedModule.provideBloc( 
              feedRepository: context.read<IFeedRepository>(),
            )..add(RefreshFeed()),
          ),
          BlocProvider<AuthBloc>(
            create: (final BuildContext context) => AuthModule.provideBloc(
              authRepository: context.read<IAuthRepository>(),
              geolocatorService: context.read<IGeolocatorService>(),
              presenceService: context.read<IPresenceService>(),
            ),
          ),
        BlocProvider<MapBloc>(
          create: (final BuildContext context) => MapBloc(
            mapRepository: context.read<IMapRepository>(),
            spotifyRepository: context.read<ISpotifyRepository>(),
          )..add(LoadMapProfiles()),
        ),
        BlocProvider<SessionBloc>(
          create: (final BuildContext context) => SessionModule.provideBloc(
            repository: context.read<ISessionRepository>(),
          )..add(LoadSession()),
        ),
        BlocProvider<SpotifyProfileCubit>(
          create: (final BuildContext context) => SpotifyProfileCubit(
            context.read<ISpotifyRepository>(),
          ),
        ),
        ],
        child: MaterialApp.router(
          title: 'localplayers',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromRGBO(186, 158, 99, 1),
            ),
            textTheme: TextTheme(
              bodyLarge: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              bodyMedium: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
              bodySmall: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white,
              ),
              titleMedium: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
              ),
              titleLarge: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          routerConfig: router,
        ),
      ),
    );
}