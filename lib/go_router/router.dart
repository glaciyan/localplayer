import 'package:go_router/go_router.dart';
import 'package:testappflt/ui/app/my_home_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const MyHomePage(title: "Home Page"),
    ),
  ],
);