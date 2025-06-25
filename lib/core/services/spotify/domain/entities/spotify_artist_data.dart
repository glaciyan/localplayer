import 'package:localplayer/core/services/spotify/domain/entities/track_entity.dart';

class SpotifyArtistData {
  final String name;
  final String genres;
  final String imageUrl;
  final String biography;
  final List<TrackEntity> tracks;
  final int popularity;
  final int listeners;

  SpotifyArtistData({
    required this.name,
    required this.genres,
    required this.imageUrl,
    required this.biography,
    required this.tracks,
    required this.popularity,
    required this.listeners,
  });
}

