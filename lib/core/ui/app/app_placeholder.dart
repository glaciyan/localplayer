import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';

class AppPlaceholder extends StatelessWidget {
  const AppPlaceholder({super.key, required this.title});
  final String title;

  int _getTabIndex() {
    switch (title.toLowerCase()) {
      case 'feed':
        return 2;
      case 'profile':
        return 3;
      case 'match':
      case 'swipe':
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WithNavBar(
      selectedIndex: _getTabIndex(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the $title screen.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go("/"),
              child: const Text('Go Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
