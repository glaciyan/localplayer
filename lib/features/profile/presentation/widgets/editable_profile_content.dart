import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/profile/presentation/widgets/avatar_section.dart';
import 'package:localplayer/features/profile/presentation/widgets/spotify_tracks_section.dart';
import 'package:localplayer/features/profile/presentation/widgets/text_field_section.dart';

class EditableProfileContent extends StatelessWidget {
  final ProfileWithSpotify profile;
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController spotifyIdController;

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProfileWithSpotify>('profile', profile));
    properties.add(DiagnosticsProperty<TextEditingController>('nameController', nameController));
    properties.add(DiagnosticsProperty<TextEditingController>('bioController', bioController));
    properties.add(DiagnosticsProperty<TextEditingController>('spotifyIdController', spotifyIdController));
  }

  const EditableProfileContent({
    super.key,
    required this.profile,
    required this.nameController,
    required this.bioController,
    required this.spotifyIdController,
  });

  @override
  Widget build(final BuildContext context) => Column(
      children: <Widget> [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
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
