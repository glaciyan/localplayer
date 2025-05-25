// custom_navbar.dart
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  static const double? icon_size = 30;

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
          icon: Iconify(Mdi.map_marker_outline, size: icon_size),
          selectedIcon: Iconify(Mdi.map_marker, size: icon_size),
          label: 'Map',
        ),
        NavigationDestination(
          icon: Iconify(Mdi.cards_outline, size: icon_size),
          selectedIcon: Iconify(Mdi.cards, size: icon_size),
          label: 'Match',
        ),
        NavigationDestination(
          icon: Iconify(Mdi.lightning_bolt_outline, size: icon_size),
          selectedIcon: Iconify(Mdi.lightning_bolt, size: icon_size),
          label: 'Feed',
        ),
        NavigationDestination(
          icon: Iconify(Mdi.chat_outline, size: icon_size),
          selectedIcon: Iconify(Mdi.chat, size: icon_size),
          label: 'Sessions',
        ),
      ],
    );
  }
}