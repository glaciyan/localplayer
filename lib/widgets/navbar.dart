// custom_navbar.dart
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  // ignore: constant_identifier_names
  static const double iconsize = 25;
  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(
          icon: Iconify(Mdi.map_marker_outline, size: iconsize),
          selectedIcon: Iconify(Mdi.map_marker, size: iconsize),
          label: 'Map',
        ),
        NavigationDestination(
          icon: Iconify(Mdi.cards_outline, size: iconsize),
          selectedIcon: Iconify(Mdi.cards, size: iconsize),
          label: 'Match',
        ),
        NavigationDestination(
          icon: Iconify(Mdi.lightning_bolt_outline, size: iconsize),
          selectedIcon: Iconify(Mdi.lightning_bolt, size: iconsize),
          label: 'Feed',
        ),
        NavigationDestination(
          icon: Iconify(Mdi.chat_outline, size: iconsize),
          selectedIcon: Iconify(Mdi.chat, size: iconsize),
          label: 'Sessions',
        ),
      ],
    );
  }
}