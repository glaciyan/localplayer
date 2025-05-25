import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/widgets/navbar.dart';

import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';
import '../blocs/navigation/navigation_state.dart';

import '../screens/feed/feed_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/match/match_screen.dart';
import '../screens/map/map_screen.dart';

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        Widget currentScreen;
        int currentIndex;

        if (state is NavigationMap) {
          currentScreen = const MapScreen();
          currentIndex = 0;
        } else if (state is NavigationMatch) {
          currentScreen = const MatchScreen();
          currentIndex = 1;
        } else if (state is NavigationFeed) {
          currentScreen = const FeedScreen();
          currentIndex = 2;
        } else if (state is NavigationChat) {
          currentScreen = const ChatScreen();
          currentIndex = 3;
        } else {
          currentScreen = const MapScreen();
          currentIndex = 0;
        }

        return Scaffold(
          body: SafeArea(child: currentScreen),
          bottomNavigationBar: Navbar(
            selectedIndex: currentIndex,
            onTap: (index) {
              switch (index) {
                case 0:
                  context.read<NavigationBloc>().add(NavigateToMap());
                  break;
                case 1:
                  context.read<NavigationBloc>().add(NavigateToMatch());
                  break;
                case 2:
                  context.read<NavigationBloc>().add(NavigateToFeed());
                  break;
                case 3:
                  context.read<NavigationBloc>().add(NavigateToChat());
                  break;
              }
            }
          ),
        );
      },
    );
  }
}
