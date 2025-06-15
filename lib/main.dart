import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/spotify/data/services/config_service.dart';
import 'package:localplayer/spotify/data/services/spotify_api_service.dart';
import 'package:localplayer/spotify/data/spotify_module.dart';
import 'package:localplayer/spotify/domain/repositories/track_repository.dart';
import 'package:localplayer/core/go_router/router.dart';
import 'package:localplayer/features/chat/presentation/blocs/chat_block.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_block.dart';
import 'package:localplayer/features/match/match_module.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';
import 'package:localplayer/features/map/presentation/blocs/map_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = ConfigService();
  await config.load();

  runApp(MyApp(config: config));
}


class MyApp extends StatelessWidget {
  final ConfigService config;
  const MyApp({required this.config, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SpotifyApiService>(
          create: (_) => SpotifyModule.provideService(config),
        ),
        RepositoryProvider<ITrackRepository>(
          create: (_) => SpotifyModule.provideRepository(config),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => MatchModule.provideBloc()..add(LoadProfiles())),
          BlocProvider(create: (_) => ChatBloc()),
          BlocProvider(create: (_) => FeedBloc()),
          BlocProvider(create: (_) => MapBloc()),
          // add NavigationBloc if needed
        ],
        child: MaterialApp.router(
          title: 'localplayers',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(187, 158, 100, 100),
            ),
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
