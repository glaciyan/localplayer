import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/spotify/presentation/widgets/spotify_preview_container.dart';

class SpotifyTracksSection extends StatelessWidget {
  final ProfileWithSpotify profile;

  const SpotifyTracksSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(profile.artist.name, style: Theme.of(context).textTheme.titleMedium),
        Text(profile.artist.genres, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        for (final id in profile.artist.tracks.take(3).map((t) => t.id))
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SpotifyPreviewContainer(trackId: id),
          ),
      ],
    );
  }
}
