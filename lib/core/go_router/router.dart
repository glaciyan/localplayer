import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/ui/app/app_placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:localplayer/core/ui/app/my_home_page.dart'; // Importing MyHomePage for the home route if needed in the future
import 'package:localplayer/core/widgets/splash_screen.dart';
import 'package:localplayer/features/map/presentation/screens/map_screen.dart';
import 'package:localplayer/features/match/presentation/blocs/match_block.dart';
import 'package:localplayer/features/match/presentation/screens/match_screen.dart';
import 'package:localplayer/features/match/match_module.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      path: '/swipe',
      builder: (context, state) => BlocProvider<MatchBloc>(
        create: (_) => MatchModule.provideBloc()..add(LoadProfiles()),
        child: const MatchScreen(),
      ),
    ),
    GoRoute(
      path: '/feed',
      builder: (context, state) => const AppPlaceholder(title: "Feed"),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const AppPlaceholder(title: "Profile"),
    ),
  ],
);
