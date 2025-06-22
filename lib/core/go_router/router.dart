import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localplayer/core/widgets/splash_screen.dart';
import 'package:localplayer/features/map/presentation/screens/map_screen.dart';
import 'package:localplayer/features/match/presentation/blocs/match_block.dart';
import 'package:localplayer/features/match/presentation/screens/match_screen.dart';
import 'package:localplayer/features/match/match_module.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';
import 'package:flutter/material.dart';
import 'package:localplayer/core/ui/app/placeholder_screen.dart';
import 'package:localplayer/features/feed/presentation/screens/feed_screen.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:localplayer/features/feed/feed_module.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_event.dart';


final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: <GoRoute> [
    GoRoute(
      path: '/splash',
      builder: (final BuildContext context, final GoRouterState state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (final BuildContext context, final GoRouterState state) => const MapScreen(),
    ),
    GoRoute(
      path: '/swipe',
      builder: (final BuildContext context, final GoRouterState state) => BlocProvider<MatchBloc>(
        create: (_) => MatchModule.provideBloc()..add(LoadProfiles()),
        child: const MatchScreen(),
      ),
    ),
    GoRoute(
      path: '/feed',
      builder: (final BuildContext context, final GoRouterState state) => BlocProvider<FeedBloc>(
        create: (_) => FeedModule.provideBloc()..add(TestEvent()),
        child: const FeedScreen(),
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (final BuildContext context, final GoRouterState state) 
      => const PlaceholderScreen(title: "Profile", selectedIndex: 3),
    ),
  ],
);
