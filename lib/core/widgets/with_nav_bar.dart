import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localplayer/core/widgets/navbar.dart';
import 'package:flutter/foundation.dart';

class WithNavBar extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const WithNavBar({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Widget>('child', child));
    properties.add(IntProperty('selectedIndex', selectedIndex));
  }

  void _onNavTap(final BuildContext context, final int index) {
    if (index == selectedIndex) return; 
    switch (index) {
      case 0: context.go('/map'); break;
      case 1: context.go('/swipe'); break;
      case 2: context.go('/feed'); break;
      case 3: context.go('/profile'); break;
    }
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
      body: child,
      bottomNavigationBar: Navbar(
        selectedIndex: selectedIndex,
        onTap: (final int index) => _onNavTap(context, index),
      ),
    );
}
