import 'package:flutter/material.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(final BuildContext context) => const WithNavBar(
      selectedIndex: 2,
      child: Center(
        child: Text("Feed Screen"),
      ),
    );
}