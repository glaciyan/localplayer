import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/widgets/profile_avatar.dart';
import 'package:localplayer/spotify/presentation/widgets/spotify_preview_container.dart';


class EditableProfileCard extends StatefulWidget {
  final ProfileWithSpotify profile;

  const EditableProfileCard({
    super.key,
    required this.profile,
  });

  @override
  State<EditableProfileCard> createState() => EditableProfileCardState();
}

class EditableProfileCardState extends State<EditableProfileCard> {
  late final TextEditingController nameController;
  late final TextEditingController bioController;
  late final TextEditingController spotifyIdController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.user.displayName);
    bioController = TextEditingController(text: widget.profile.user.biography);
    spotifyIdController = TextEditingController(text: widget.profile.user.spotifyId);
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    spotifyIdController.dispose();
    super.dispose();
  }

  /// Exposes the updated profile to the parent
  ProfileWithSpotify getUpdatedProfile() {
    return ProfileWithSpotify(
      user: widget.profile.user.copyWith(
        displayName: nameController.text.trim(),
        biography: bioController.text.trim(),
        spotifyId: spotifyIdController.text.trim(),
      ),
      artist: widget.profile.artist,
    );
  }

  @override
  Widget build(BuildContext context) {
    final artist = widget.profile.artist;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(artist.imageUrl, fit: BoxFit.cover),
          ),
          // Blur layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),

          // Scrollable content
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ProfileAvatar(
                        avatarLink: widget.profile.artist.imageUrl,
                        color: widget.profile.user.color ?? Colors.white,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _editableField("Name", nameController),
                            _editableField("Spotify ID", spotifyIdController),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _editableField("Biography", bioController, maxLines: 4),

                  const Divider(height: 20, thickness: 1, color: Colors.white30),

                  Text(artist.name, style: Theme.of(context).textTheme.titleMedium),
                  Text(artist.genres, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 12),

                  for (final id in artist.tracks.take(3).map((t) => t.id))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SpotifyPreviewContainer(trackId: id),
                    ),
                ],
              ),
            ),
          ),

          // Gradient at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editableField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
