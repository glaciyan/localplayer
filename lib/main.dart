import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/go_router/router.dart';
import 'package:localplayer/features/chat/presentation/blocs/chat_block.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_block.dart';
import 'package:localplayer/features/map/presentation/blocs/map_block.dart';
import 'package:localplayer/features/match/match_module.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MatchModule.provideBloc()..add(LoadProfiles())),
        BlocProvider(create: (_) => ChatBloc()),
        BlocProvider(create: (_) => FeedBloc()),
        BlocProvider(create: (_) => MapBloc()),
        // optionally add NavigationBloc if still needed
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
    );
  }
}
