import 'package:flutter/material.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(final BuildContext context) => const WithNavBar(
      selectedIndex: 3,
      child: Center(
        child: Text("Chat Screen"),
      ),
    );
}
