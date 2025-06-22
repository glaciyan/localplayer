import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/services/spotify/data/services/config_service.dart';
import 'package:localplayer/core/services/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/core/services/spotify/data/spotify_module.dart';
import 'package:localplayer/core/services/spotify/domain/repositories/track_repository.dart';
import 'package:localplayer/core/go_router/router.dart';
import 'package:localplayer/features/chat/presentation/blocs/chat_block.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:localplayer/features/match/match_module.dart';
import 'package:localplayer/features/match/presentation/blocs/match_block.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localplayer/features/map/map_module.dart';
import 'package:flutter/foundation.dart';
import 'package:localplayer/features/feed/feed_module.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ConfigService config = ConfigService();
  await config.load();

  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final ConfigService config;
  const MyApp({required this.config, super.key});

  // keine ahnung was das soll aber wegen linter rules
  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ConfigService>('config', config));
  }

  @override
  Widget build(final BuildContext context) => MultiRepositoryProvider(
      providers: <RepositoryProvider<dynamic>> [
        RepositoryProvider<SpotifyApiService>(
          create: (_) => SpotifyModule.provideService(config),
        ),
        RepositoryProvider<ITrackRepository>(
          create: (_) => SpotifyModule.provideRepository(config),
        ),
      ],
      child: MultiBlocProvider(
        providers: <BlocProvider<dynamic>> [
          BlocProvider<MatchBloc> (create: (_) => MatchModule.provideBloc()..add(LoadProfiles())),
          BlocProvider<ChatBloc>(create: (_) => ChatBloc()),
          BlocProvider<FeedBloc>(create: (_) => FeedModule.provideBloc()),
          BlocProvider<MapBloc>(create: (_) => MapModule.provideBloc()),
          // add NavigationBloc if needed
        ],
        child: MaterialApp.router(
          title: 'localplayers',
          theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(186, 158, 99, 1)
            ),
          textTheme: TextTheme(
            bodyLarge: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            bodyMedium: GoogleFonts.poppins(
              fontSize: 17,
              color: Colors.white
            ),
            bodySmall: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white
            ),
            titleMedium: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white
            ),
            titleLarge: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),  
          ),
        ),
        routerConfig: router,
        ),
      ),
    );
  }