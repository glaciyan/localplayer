import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/widgets/profile_avatar.dart';
import 'package:localplayer/spotify/presentation/widgets/spotify_preview_container.dart';
import 'package:localplayer/spotify/domain/entities/track_entity.dart';
import 'package:flutter/foundation.dart';

class ProfileCard extends StatelessWidget {
  final ProfileWithSpotify profile;

  const ProfileCard({super.key, required this.profile});

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProfileWithSpotify>('profile', profile));
  }

  @override
  Widget build(final BuildContext context) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      children: <Widget>[
        // Background image
        Positioned.fill(
          child: Image.network(profile.artist.imageUrl, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
            child: Container(color: Colors.black.withAlpha(128)),
          ),
        ),

        // Scrollable foreground content
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // USER INFO
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ProfileAvatar(
                      avatarLink: profile.artist.imageUrl,
                      color: profile.user.color ?? Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(profile.user.displayName, style: Theme.of(context).textTheme.titleLarge),
                        Text(profile.user.location, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (profile.user.biography.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      profile.user.biography,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                const Divider(height: 20, thickness: 1, color: Colors.white30),

                // SPOTIFY ARTIST INFO
                Text(profile.artist.name, style: Theme.of(context).textTheme.titleMedium),
                Text(profile.artist.genres, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),

                for (final String id in profile.artist.tracks.take(3).map((final TrackEntity track) => track.id))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SpotifyPreviewContainer(trackId: id),
                  ),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ),

        // Gradient
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
  );
}
