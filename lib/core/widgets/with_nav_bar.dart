import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localplayer/core/widgets/navbar.dart';

class WithNavBar extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const WithNavBar({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/'); break;
      case 1: context.go('/swipe'); break;
      case 2: context.go('/feed'); break;
      case 3: context.go('/profile'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Navbar(
        selectedIndex: selectedIndex,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}
