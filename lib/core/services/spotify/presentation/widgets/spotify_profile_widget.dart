import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localplayer/core/services/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';
import 'package:localplayer/core/services/spotify/presentation/widgets/spotify_preview_container.dart';

class SpotifyProfileWidget extends StatelessWidget {
  final SpotifyArtistData artist;

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SpotifyArtistData>('artist', artist));
  }

  const SpotifyProfileWidget({super.key, required this.artist});

  @override
  Widget build(final BuildContext context) => Stack(
      children: <Widget>[
        // Background image with blur
        Positioned.fill(
          child: Image.network(artist.imageUrl, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
        ),

        // Main content
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(artist.name, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(artist.genres, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 20),
                      Text(artist.biography, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 20),
                      for (final TrackEntity track in artist.tracks.take(3))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: SpotifyPreviewContainer(track: track,),
                        ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Gradient overlay
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 350,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: <Color> [Colors.black87, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
}
