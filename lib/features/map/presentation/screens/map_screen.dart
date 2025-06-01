import 'package:flutter/material.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';


class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WithNavBar(
      selectedIndex: 0,
      child: Center(
        child: Text("Map Screen"),
      ),
    );
  }
}
