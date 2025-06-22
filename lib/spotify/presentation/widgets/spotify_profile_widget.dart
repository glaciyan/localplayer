import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localplayer/spotify/domain/entities/spotify_artist_data.dart';
import 'package:localplayer/spotify/presentation/widgets/spotify_preview_container.dart';

class SpotifyProfileWidget extends StatelessWidget {
  final SpotifyArtistData artist;

  const SpotifyProfileWidget({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image with blur
        Positioned.fill(
          child: Image.network(artist.imageUrl, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 20),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
        ),

        // Main content
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(artist.name, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(artist.genres, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 20),
                      Text(artist.biography, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 20),
                      for (final track in artist.tracks.take(3))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: SpotifyPreviewContainer(trackId: track.id),
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
                colors: [Colors.black87, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
