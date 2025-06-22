// cores/domain/entities/track_entity.dart
class TrackEntity {
  final String id;
  final String name;
  final String artist;
  final String imageUrl;
  final String? previewUrl;

  const TrackEntity({
    required this.id,
    required this.name,
    required this.artist,
    required this.imageUrl,
    this.previewUrl,
  });
}
