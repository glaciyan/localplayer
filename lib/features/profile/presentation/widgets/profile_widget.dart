import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/widgets/profile_card.dart';
import 'package:flutter/foundation.dart';


class ProfileWidget extends StatelessWidget {
  final ProfileWithSpotify profile;
  final VoidCallback onEdit;
  final VoidCallback onCreateSession;

  const ProfileWidget({
    super.key,
    required this.profile,
    required this.onEdit,
    required this.onCreateSession,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Fullscreen ProfileCard
            Positioned.fill(
              child: ProfileCard(profile: profile),
            ),

            // Buttons always fixed at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Row(
    children: <Widget>[
      Expanded(
        child: ElevatedButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit, size: 28),
          label: const Text(
            "Edit Profile",
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(60),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: ElevatedButton.icon(
          onPressed: onCreateSession,
          icon: const Icon(Icons.play_arrow, size: 28),
          label: const Text(
            "Create Session",
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(60),
          ),
        ),
      ),
    ],
  ),
),

            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProfileWithSpotify>('profile', profile));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onEdit', onEdit));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onCreateSession', onCreateSession));
  }
}
