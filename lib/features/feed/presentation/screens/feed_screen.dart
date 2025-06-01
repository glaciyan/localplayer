import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WithNavBar(
      selectedIndex: 2,
      child: Center(
        child: Text("Feed Screen"),
      ),
    );
  }
}