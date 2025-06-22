import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/widgets/profile_card.dart';


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
    return Column(
      children: [
        // Scrollable profile content
        Expanded(
          child: ProfileCard(profile: profile),
        ),

        // Sticky buttons at the bottom
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onCreateSession,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Create Session"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
