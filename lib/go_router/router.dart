import 'package:go_router/go_router.dart';
import 'package:localplayer/ui/app/my_home_page.dart';
import 'package:localplayer/ui/app/placeholder.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const MyHomePage(title: "Home Page"),
    ),
    GoRoute(
      path: "/swipe",
      builder: (context, state) => const Placeholder(title: "Swipe"),
    ),
    GoRoute(
      path: "/feed",
      builder: (context, state) => const Placeholder(title: "Feed"),
    ),
    GoRoute(
      path: "/profile",
      builder: (context, state) => const Placeholder(title: "Profile"),
    ),
  ],
);