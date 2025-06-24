// custom_navbar.dart
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:flutter/foundation.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  static const double icon_size = 25;

  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('selectedIndex', selectedIndex));
    properties.add(ObjectFlagProperty<ValueChanged<int>>('onTap', onTap, ifPresent: 'has callback'));
  }

  @override
  Widget build(final BuildContext context) => NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onTap,
      destinations: <NavigationDestination> [
        NavigationDestination(
          icon: Iconify(Mdi.map_marker_outline, size: icon_size),
          selectedIcon: Iconify(Mdi.map_marker, size: icon_size),
          label: 'Map',
        ),
        NavigationDestination(
          icon: Iconify(Mdi.cards_outline, size: icon_size),
          selectedIcon: Iconify(Mdi.cards, size: icon_size),
          label: 'Rate',
        ),
        NavigationDestination(
          icon: Iconify(Mdi.lightning_bolt_outline, size: icon_size),
          selectedIcon: Iconify(Mdi.lightning_bolt, size: icon_size),
          label: 'Feed',
        ),
        NavigationDestination(
          icon: Iconify(Mdi.account_outline, size: icon_size),
          selectedIcon: Iconify(Mdi.account, size: icon_size),
          label: 'Profile',
        ),
      ],
    );
}