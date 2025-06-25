import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/core/widgets/profile_avatar.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/core/services/spotify/presentation/widgets/spotify_preview_container.dart';
import 'package:flutter/foundation.dart';


class EditableProfileCard extends StatefulWidget {
  final ProfileWithSpotify profile;

  const EditableProfileCard({
    super.key,
    required this.profile,
  });

  @override
  State<EditableProfileCard> createState() => EditableProfileCardState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProfileWithSpotify>('profile', profile));
  }
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
  ProfileWithSpotify getUpdatedProfile() => ProfileWithSpotify(
      user: widget.profile.user.copyWith(
        displayName: nameController.text.trim(),
        biography: bioController.text.trim(),
        spotifyId: spotifyIdController.text.trim(),
      ),
      artist: widget.profile.artist,
    );


  @override
  Widget build(final BuildContext context) {
    final SpotifyArtistData artist = widget.profile.artist;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: <Widget>[
              // background image
              Positioned.fill(
                child: Image.network(artist.imageUrl, fit: BoxFit.cover),
              ),
              // blur layer
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
                  child: Container(color: Colors.black.withValues(alpha: 0.5)),
                ),
              ),
              // main content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                ProfileAvatar(
                                  avatarLink: widget.profile.artist.imageUrl,
                                  color: widget.profile.user.color ?? Colors.white,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
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

                            for (final TrackEntity track in artist.tracks.take(3))
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: SpotifyPreviewContainer(track: track),
                              ),

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // gradient at bottom
              // Bottom gradient
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 300,
                child: IgnorePointer(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: <Color>[Colors.black87, Colors.transparent],
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }


  Widget _editableField(final String label, final TextEditingController controller, {final int maxLines = 1}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
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


  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProfileWithSpotify>('profile', widget.profile));
    properties.add(DiagnosticsProperty<TextEditingController>('nameController', nameController));
    properties.add(DiagnosticsProperty<TextEditingController>('bioController', bioController));
    properties.add(DiagnosticsProperty<TextEditingController>('spotifyIdController', spotifyIdController));
  }
}
