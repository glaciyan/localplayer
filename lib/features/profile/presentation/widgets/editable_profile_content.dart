import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/profile/presentation/widgets/avatar_section.dart';
import 'package:localplayer/features/profile/presentation/widgets/spotify_tracks_section.dart';
import 'package:localplayer/features/profile/presentation/widgets/text_field_section.dart';

class EditableProfileContent extends StatelessWidget {
  final ProfileWithSpotify profile;
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController spotifyIdController;

  const EditableProfileContent({
    super.key,
    required this.profile,
    required this.nameController,
    required this.bioController,
    required this.spotifyIdController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarSection(profile: profile),
                const SizedBox(height: 16),
                TextFieldsSection(
                  nameController: nameController,
                  bioController: bioController,
                  spotifyIdController: spotifyIdController,
                ),
                const Divider(height: 20, thickness: 1, color: Colors.white30),
                SpotifyTracksSection(profile: profile),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
