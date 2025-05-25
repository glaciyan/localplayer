import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/screens/main_navigation_view.dart';
import 'blocs/navigation/navigation_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => NavigationBloc(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (_) => NavigationBloc(),
        ),
        /*
        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(),
        ),
        BlocProvider<MatchBloc>(
          create: (_) => MatchBloc(),
        ),
        BlocProvider<FeedBloc>(
          create: (_) => FeedBloc(),
        ),
        BlocProvider<MapBloc>(
          create: (_) => MapBloc(),
        ),
        */
      ],
      child: MaterialApp(
        title: 'localplayers',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(187, 158, 100, 100)
          )
        ),
        home: MainNavigationView()
      )
    );
  }
}
