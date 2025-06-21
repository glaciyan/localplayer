import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final int selectedIndex;
  
  const PlaceholderScreen({
    super.key, 
    required this.title, 
    required this.selectedIndex,
  });

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(IntProperty('selectedIndex', selectedIndex));
  }

  @override
  Widget build(final BuildContext context) => WithNavBar(
    selectedIndex: selectedIndex,
    child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              ),
            ),
          ],
        ),
      ),
    ),
  );
} 