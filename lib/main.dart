import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/features/map/data/repositories/map_repository_impl.dart';
import 'package:localplayer/features/map/domain/repositories/i_map_repository.dart';
import 'package:localplayer/features/map/presentation/blocs/map_event.dart';
import 'package:localplayer/features/profile/domain/repositories/i_user_repository.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:localplayer/features/profile/user_module.dart';
import 'package:localplayer/spotify/data/services/config_service.dart';
import 'package:localplayer/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/spotify/data/spotify_module.dart';
import 'package:localplayer/spotify/domain/repositories/spotify_repository.dart';
import 'package:localplayer/spotify/domain/repositories/track_repository.dart';
import 'package:localplayer/core/go_router/router.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:localplayer/features/match/match_module.dart';
import 'package:localplayer/features/match/presentation/blocs/match_bloc.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localplayer/spotify/domain/usecases/get_spotify_artist_data_use_case.dart';
import 'package:localplayer/spotify/presentation/blocs/spotify_profiel_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:localplayer/features/feed/feed_module.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ConfigService config = ConfigService();
  await config.load();
  final Dio dio = Dio();
  final IUserRepository userRepo = UserModule.provideRepository(dio);
  runApp(MyApp(config: config, userRepo: userRepo,));
}

class MyApp extends StatelessWidget {
  final ConfigService config;
  final IUserRepository userRepo;

  const MyApp({
    required this.config,
    required this.userRepo,
    super.key,
  });

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ConfigService>('config', config));
    properties.add(DiagnosticsProperty<IUserRepository>('userRepo', userRepo));
  }

  @override
  Widget build(final BuildContext context) => MultiRepositoryProvider(
      providers: <RepositoryProvider<dynamic>>[
        RepositoryProvider<IUserRepository>.value(value: userRepo),
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
          create: (final BuildContext context) => MapRepository(context.read<ISpotifyRepository>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<MatchBloc>(
            create: (final BuildContext context) => MatchModule.provideBloc(
              spotifyRepository: context.read<ISpotifyRepository>(),
            )..add(LoadProfiles()),
          ),
          BlocProvider<ProfileBloc>(
            create: (final BuildContext context) => UserModule.provideBloc(
              userRepo,
              config,
            ),
          ),
          BlocProvider<FeedBloc>(create: (_) => FeedModule.provideBloc()),
          BlocProvider<MapBloc>(
            create: (final BuildContext context) => MapBloc(
              mapRepository: context.read<IMapRepository>(),
              spotifyRepository: context.read<ISpotifyRepository>(),
            )..add(LoadMapProfiles()),
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
                fontSize: 16,
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