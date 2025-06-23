import 'package:go_router/go_router.dart';
// Importing MyHomePage for the home route if needed in the future
import 'package:localplayer/core/widgets/splash_screen.dart';
import 'package:localplayer/features/feed/presentation/screens/feed_screen.dart';
import 'package:localplayer/features/map/presentation/screens/map_screen.dart';
import 'package:localplayer/features/match/presentation/screens/match_screen.dart';

import 'package:localplayer/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:localplayer/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';

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
      builder: (final BuildContext context, final GoRouterState state) => const MatchScreen(),
      ),
    GoRoute(
      path: '/feed',
      builder: (final BuildContext context, final GoRouterState state) => const FeedScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (final BuildContext context, final GoRouterState state) => const ProfileScreen()
    ),
    GoRoute(
      path: '/profile/edit', 
      builder: (final BuildContext context, final GoRouterState state) => EditProfileScreen()),
  ],
);