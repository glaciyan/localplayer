import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/match/domain/entities/user_profile.dart';
import 'package:localplayer/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/spotify/presentation/widgets/spotifiy_profile_container.dart';
import 'package:localplayer/core/widgets/profile_avatar.dart';
import 'package:localplayer/spotify/presentation/widgets/spotify_preview_container.dart';

class ProfileCard extends StatelessWidget {
  final ProfileWithSpotify profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(profile.artist.imageUrl, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),

          // Foreground content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // USER INFO
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ProfileAvatar(
                              avatarLink: profile.artist.imageUrl,
                              color: profile.user.color ?? Colors.white,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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

                        for (final id in profile.artist.tracks.take(3).map((t) => t.id))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: SpotifyPreviewContainer(trackId: id),
                          ),

                        const SizedBox(height: 100), // Leave scroll space
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom gradient
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
}
