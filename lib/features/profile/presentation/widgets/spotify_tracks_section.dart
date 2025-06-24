import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/core/services/spotify/presentation/widgets/spotify_preview_container.dart';

class SpotifyTracksSection extends StatelessWidget {
  final ProfileWithSpotify profile;
  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProfileWithSpotify>('profile', profile));
  }

  const SpotifyTracksSection({super.key, required this.profile});

  @override
  Widget build(final BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        Text(profile.artist.name, style: Theme.of(context).textTheme.titleMedium),
        Text(profile.artist.genres, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        for (final TrackEntity track in profile.artist.tracks.take(3))
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SpotifyPreviewContainer(track: track),
          ),
      ],
    );
}
